require 'spec_helper'
require './spec/testing/directory'

describe Fargo do
  context "set a root path" do
    it "#set_root" do
      directory = Fargo::Directory.set_root('//')
      Fargo::Directory.structure.count.should eq(1)
      directory.basename.should eq('..')
    end
  end

  context "modify directories" do
    let!(:root) { Fargo::Directory.set_root('//') }

    it "adds a new directory" do
      directory = Fargo::Directory.new('a_new_folder')
      Fargo::Directory.structure.count.should eq(2)
    end

    it "only adds one instance of a folder" do
      directory = Fargo::Directory.new('a_dup_folder')
      directory = Fargo::Directory.new('a_dup_folder')
      Fargo::Directory.structure.count.should eq(2)
    end
  end
end
