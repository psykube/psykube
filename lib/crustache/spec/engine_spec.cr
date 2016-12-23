require "./spec_helper"

describe Crustache::Engine do
  describe "#initialize" do
    it "should return a new instance" do
      Crustache::Engine.new(Crustache::HashFileSystem.new).should be_truthy
      Crustache::Engine.new("", true).should be_truthy
    end
  end

  describe "#render" do
    it "should render a template" do
      engine = Crustache::Engine.new Crustache::HashFileSystem.new
      engine.render(Crustache.parse("Test {{.}}"), "Test").should eq("Test Test")
    end

    it "should render a template" do
      fs = Crustache::HashFileSystem.new
      fs.register "test", Crustache.parse "Test {{.}}"
      engine = Crustache::Engine.new fs
      engine.render("test", "Test").should eq("Test Test")
    end

    it "should render a template with output IO object" do
      fs = Crustache::HashFileSystem.new
      fs.register "test", Crustache.parse "Test {{.}}"
      engine = Crustache::Engine.new fs
      output = IO::Memory.new
      engine.render("test", "Test", output)
      output.to_s.should eq("Test Test")
    end
  end

  describe "#render!" do
    it "should render a template" do
      fs = Crustache::HashFileSystem.new
      fs.register "test", Crustache.parse "Test {{.}}"
      engine = Crustache::Engine.new fs
      engine.render!("test", "Test").should eq("Test Test")
    end

    it "should raise an error" do
      fs = Crustache::HashFileSystem.new
      engine = Crustache::Engine.new fs
      expect_raises do
        engine.render!("test", "Test")
      end
    end
  end
end
