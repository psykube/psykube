require "spec"
require "http/client"
require "uuid"
require "../src/psykube"
require "../src/cli/main"

NAMESPACE = "psykube-test-#{UUID.random}"

class Exited < Exception; end

class Admiral::Command
  def exit(int : Int32 = 0)
    raise Exited.new("exited")
  end
end

def kubectl(args : String)
  bin = Psykube::CLI::Commands::Kubectl.bin
  File.exists?(bin) || raise("kubectl not found")
  Process.run(bin, args.split(" "))
end

macro psykube_it(command, timeout = 30)
  command = {{command}}
  it "should run `psykube #{command}` and not fail" do
    puts ""
    Psykube::CLI.run({{ command }})
  end
end

Dir.cd("spec") do
  describe Psykube::CLI do
    it "should set up the environment" do
      kubectl "delete namespace #{NAMESPACE}"
      kubectl "create namespace #{NAMESPACE}"
      kubectl "--namespace=#{NAMESPACE} run hello-world --image=hello-world --port=80 --expose"
    end

    psykube_it "init --overwrite --namespace=#{NAMESPACE} --name=psykube-test --registry-host=gcr.io --registry-user=commercial-tribe --port http=80"
    psykube_it "generate default"
    psykube_it "apply default"
    psykube_it "status default"
    psykube_it "push"

    it "should run exec" do
      Process.fork { Psykube::CLI.run "exec default -- echo 'hello world'" }.wait
    end

    it "should port forward" do
      process = Process.fork { Psykube::CLI.run "port-forward default 9292:80" }
      sleep 5
      HTTP::Client.get("http://localhost:9292").body.lines.first.strip.should eq "hello psykube"
      process.kill
      process.wait
    end

    it "should show logs" do
      process = Process.fork { Psykube::CLI.run "logs default" }
      sleep 5
      process.kill
      process.wait
    end

    psykube_it "copy-namespace #{NAMESPACE} #{NAMESPACE}-copy --force"

    # Cleanup
    psykube_it "delete default -y"

    it "deletes the namespace" do
      kubectl "delete namespace #{NAMESPACE}-copy"
      kubectl "delete namespace #{NAMESPACE}"
    end
  end
end
