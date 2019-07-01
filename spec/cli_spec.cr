require "spec"
require "http/client"
require "uuid"
require "../src/psykube"
require "../src/cli/main"

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
  ["", " --v1"].each do |v|
    namespace = "psykube-test-#{UUID.random}"

    describe Psykube::CLI do
      psykube_it "init --overwrite --namespace=#{namespace} --name=psykube-test --registry-host=registry.gitlab.com --registry-user=psykube/psykubs --port http=80 #{v}"
      psykube_it "create-namespace"
      psykube_it "generate"
      psykube_it "apply"
      psykube_it "status"
      psykube_it "push"

      # it "should run exec" do
      #   Process.fork { Psykube::CLI.run "exec -- echo 'hello world'" }.wait
      # end
      #
      # it "should port forward" do
      #   process = Process.fork { Psykube::CLI.run "port-forward 9292:80" }
      #   sleep 5
      #   HTTP::Client.get("http://localhost:9292").body.lines.first.strip.should eq "hello psykube"
      #   process.kill
      #   process.wait
      # end
      #
      # it "should show logs" do
      #   process = Process.fork { Psykube::CLI.run "logs" }
      #   sleep 5
      #   process.kill
      #   process.wait
      # end

      psykube_it "copy-namespace #{namespace} #{namespace}-copy --force"

      # Cleanup
      psykube_it "delete -y"
      psykube_it "delete-namespace -y"

      it "deletes the namespace" do
        kubectl "delete namespace #{namespace}-copy"
        kubectl "delete namespace #{namespace}"
      end
    end
  end
end
