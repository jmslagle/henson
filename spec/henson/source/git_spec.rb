require "spec_helper"

describe Henson::Source::Git do
  it "can be instantiated" do
    expect(Henson::Source::Git.new("foo", :bar => :baz)).to_not be_nil
  end

  describe "#fetched?" do
    it "returns false if the repo is not cloned" do
      expect(Henson::Source::Git.new("foo", :bar => :baz)).to_not be_fetched
    end

    let(:git) do
      lambda { |opts = {}|
        Henson::Source::Git.new "osx_defaults",
          "https://github.com/wfarr/puppet-osx_defaults",
          opts
      }
    end
    it "returns false if the repo does not have the correct revision" do
      lgit = git.(:ref => "0123456")
      lgit.fetch!
      expect(lgit).to_not be_fetched
    end
    it "returns true if cloned and the correct revision" do
      lgit = git.(:ref => "ff5e337")
      lgit.fetch!
      expect(lgit).to be_fetched
    end

  end

  describe "#fetch!" do
    it "clones the repository and checks out the revision"
  end

  describe "#install!" do
    it "moves the repository tracked files from the tmp path to install path"
    it "logs an info level install message"
    it "logs a debug level install message"
  end

  describe "#versions" do
    it "returns the target revision as the only version available"
  end

  describe "#valid?" do
    it "returns true if the repo can be cloned"
    it "returns false if the repo cannot be cloned"
    it "returns false if the revision does not exist"
  end

  describe "#target_revision" do
    let(:git) do
      lambda { |opts = {}|
        Henson::Source::Git.new "osx_defaults",
          "https://github.com/wfarr/puppet-osx_defaults",
          opts
      }
    end

    it "returns branch if options branch" do
      expect(git.(:branch => "fuckit").send(:target_revision)).to eq("origin/fuckit")
    end

    it "returns tag if options tag" do
      expect(git.(:tag => "foo").send(:target_revision)).to eq("foo")
    end

    it "returns ref if options ref" do
      expect(git.(:ref => "123abc").send(:target_revision).to_s).to eq("123abc")
    end

    it "returns master otherwise" do
      expect(git.().send(:target_revision)).to eq("origin/master")
    end
  end
end
