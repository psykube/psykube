require "./spec_helper.cr"

describe Crustache::ViewLoader do
  it "should load a template file" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view"
    fs.load("template.mustache").should be_truthy
  end

  it "should load a template file without an extension" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view"
    fs.load("template").should be_truthy
  end

  it "should load a template file without an extension" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view"
    fs.load("template_html").should be_truthy
  end

  it "should load a template file without an extension" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view", use_cache: false, extension: [".test"]
    fs.load("template_test").should be_truthy
  end

  it "should return nil if specified template file is not found" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view"
    fs.load("template_not_found").should be_falsey
  end

  it "should cache a template file" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view", true
    File.write "#{__DIR__}/view/template2.mustache", "Hello, {{Mustache}} World!"
    fs.load("template2").should be_truthy
    File.delete "#{__DIR__}/view/template2.mustache"
    fs.load("template2").should be_truthy
  end

  it "shouldn't cache a template file" do
    fs = Crustache::ViewLoader.new "#{__DIR__}/view", false
    File.write "#{__DIR__}/view/template2.mustache", "Hello, {{Mustache}} World!"
    fs.load("template2").should be_truthy
    File.delete "#{__DIR__}/view/template2.mustache"
    fs.load("template2").should be_falsey
  end
end
