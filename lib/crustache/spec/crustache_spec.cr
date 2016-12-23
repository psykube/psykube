require "./spec_helper"

describe Crustache do
  describe "#parse" do
    it "shold parse a string" do
      Crustache.parse("Hello, {{Mustache}} World").should be_truthy
    end

    it "should parse a IO" do
      Crustache.parse(IO::Memory.new "Hello, {{Mustache}} World").should be_truthy
    end

    it "raise a parse error" do
      expect_raises(Crustache::ParseError) do
        Crustache.parse("Hello, {{Mustache? World")
      end
    end
  end

  describe "#parse_file" do
    it "should parse a file" do
      tmpl = Crustache.parse_file("#{__DIR__}/view/template.mustache")
      tmpl.should be_a Crustache::Template
    end
  end

  describe "#parse_file_static" do
    it "should parse a file on compile time" do
      tmpl = Crustache.parse_file_static("#{__DIR__}/view/template.mustache")
      tmpl.should be_a Crustache::Template
    end
  end

  describe "#loader" do
    it "should create loader object" do
      loader = Crustache.loader "#{__DIR__}/view/"

      loader.load("template").should be_a Crustache::Template
      loader.load("template.mustache").should be_a Crustache::Template
      loader.load("template_html").should be_a Crustache::Template
      loader.load("template_html.html").should be_a Crustache::Template
      loader.load("template_test").should be_a Crustache::Template
      loader.load("template_test.html").should be_a Crustache::Template
    end

    it "should create loader object" do
      loader = Crustache.loader "#{__DIR__}/view"

      loader.load("template").should be_a Crustache::Template
      loader.load("template.mustache").should be_a Crustache::Template
      loader.load("template_html").should be_a Crustache::Template
      loader.load("template_html.html").should be_a Crustache::Template
      loader.load("template_test").should be_a Crustache::Template
      loader.load("template_test.html").should be_a Crustache::Template
    end
  end
  describe "#loader_static" do
    it "should create loader object on compile time" do
      loader = Crustache.loader_static "#{__DIR__}/view/"

      loader.load("template").should be_a Crustache::Template
      loader.load("template.mustache").should be_a Crustache::Template
      loader.load("template_html").should be_a Crustache::Template
      loader.load("template_html.html").should be_a Crustache::Template
      loader.load("template_test").should be_a Crustache::Template
      loader.load("template_test.html").should be_a Crustache::Template
    end

    it "should create loader object on compile time" do
      loader = Crustache.loader_static "#{__DIR__}/view"

      loader.load("template").should be_a Crustache::Template
      loader.load("template.mustache").should be_a Crustache::Template
      loader.load("template_html").should be_a Crustache::Template
      loader.load("template_html.html").should be_a Crustache::Template
      loader.load("template_test").should be_a Crustache::Template
      loader.load("template_test.html").should be_a Crustache::Template
    end
  end

  describe "#render" do
    it "should render a template" do
      Crustache.render(Crustache.parse("Test {{.}}"), "Test").should eq("Test Test")
    end
  end
end
