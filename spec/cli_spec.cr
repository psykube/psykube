require "spec/dsl"
require "../src/psykube/cli"
require "http/client"

class Exited < Exception; end

class Admiral::Command
  def exit(int : Int32 = 0)
    raise Exited.new("exited")
  end
end

def kubectl(args : String)
  kubectl = ENV["KUBECTL_BIN"]? || `which kubectl`
  Process.run(kubectl, args.split(" "))
end

macro psykube(command, timeout = 30)
  it "should run `psykube {{command.id}}` and not fail" do
    puts ""
    Dir.cd("spec") do
      Psykube::CLI.run({{ command.id.stringify }}).should eq nil
    end
  end
end

kubectl "delete namespace"
kubectl "create namespace psykube-test"
kubectl "--namespace=psykube-test run hello-world --image=tutumcloud/hello-world --port=80 --expose"

Spec.override_default_formatter Spec::VerboseFormatter.new

describe "cli" do
  psykube "init --overwrite --name=psykube-test"
  psykube "generate default"
  psykube "apply default"
  psykube "status default"
  psykube "push"

  it "should run exec" do
    Process.fork do
      Psykube::CLI.run "exec default -- echo 'hello world'"
    end.wait
  end

  it "should port forward" do
    Dir.cd("spec") do
      process = Process.fork { Psykube::CLI.run "port-forward default 9292:80" }
      sleep 5
      HTTP::Client.get("http://localhost:9292").body.lines.first.strip.should eq "hello psykube"
      process.kill
      process.wait
    end
  end

  it "should show logs" do
    Dir.cd("spec") do
      process = Process.fork { Psykube::CLI.run "logs default" }
      sleep 5
      process.kill
      process.wait
    end
  end

  psykube "copy-namespace psykube-test psykube-test-copy --force"

  # Cleanup
  psykube "delete default -y"
end

kubectl "delete namespace psykube-test-copy"
