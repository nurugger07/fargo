require 'spec_helper'
require './spec/testing/directory'

describe Fargo do
  let!(:root) { Fargo::Directory.set_root('//') }

  describe ".set_root" do
    it "sets a root path" do
      directory = root
      Fargo::Directory.structure.count.should eq(1)
      directory.basename.should eq('..')
    end
  end


  describe "finding folders and files" do
    let!(:directory) { Fargo::Directory.new('existing_folder') }
    let!(:file) { Fargo::Directory.new('existing_file.rb', file=true) }

    describe ".find" do
      it "finds an existing path in the structure" do
        Fargo::Directory.find('existing_folder')
        .path.should eq('existing_folder')
      end

      it "returns nil if the path isn't found" do
        Fargo::Directory.find('non_existing_folder').should be_nil
      end
    end

    describe ".find_directory" do
      it "finds directory in the structure" do
        Fargo::Directory.find_directory("existing_folder")
          .path.should eq("existing_folder")
      end

      it "returns nil if the path is a file" do
        Fargo::Directory.find_directory("existing_file.rb")
          .should be_nil
      end
    end

    describe ".find_file" do
      it "finds file in the structure" do
        Fargo::Directory.find_file("existing_file.rb")
          .path.should eq("existing_file.rb")
      end

      it "returns nil if the path is a folder" do
        Fargo::Directory.find_file("existing_folder")
          .should be_nil
      end

      it "returns nil if the file doesn't exist" do
        Fargo::Directory.find_file("i_dont_exist")
          .should be_nil
      end
    end
  end

  context "on initialize" do
    before do
      Fargo::Directory.structure.count.should eq(1)
    end

    it "adds the new folder to the structure" do
      Fargo::Directory.new('a_new_folder')
      Fargo::Directory.structure.count.should eq(2)
    end

    it "adds the new file to the structure" do
      file = Fargo::Directory.new("new_file.rb", true)
      file.file?.should be_true
    end

    it "rejects duplicates in the structure" do
      Fargo::Directory.new('a_dup_folder')
      Fargo::Directory.new('a_dup_folder')
      Fargo::Directory.structure.count.should eq(2)
    end

    it "rejects additions to non-existent folders" do
      lambda { Fargo::Directory.new("non_existant_folder/new_file.rb", true) }
        .should raise_error(Errno::ENOENT)
    end
  end


  describe "directory actions" do
    before do
      Fargo::Directory.structure.count.should eq(1)
    end

    let(:folder) { Fargo::Directory.new("folder") }
    let!(:file) { Fargo::Directory.new("#{folder.path}/new_file.rb", true) }

    describe "#rename_path!" do
      it "rename an existing file" do
        file.rename_path! "folder/renamed_file.rb"
        file.path.should eq("folder/renamed_file.rb")
      end
    end

    describe "#remove_from_structure!" do
      it "removes a file" do
        structure_count = Fargo::Directory.structure.count
        file.remove_from_structure!
        Fargo::Directory.structure.count.should eq(structure_count - 1)
      end

      it "removes a folder and its sub-folder/files" do
        folder.remove_from_structure!
        Fargo::Directory.structure.count.should eq(1)
      end
    end
  end
end
