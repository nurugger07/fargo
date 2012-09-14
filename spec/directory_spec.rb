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

  describe "directory actions" do
    let!(:root) { Fargo::Directory.set_root('//') }

    context "modify folders" do
      it "adds a new folder" do
        directory = Fargo::Directory.new('a_new_folder')
        Fargo::Directory.structure.count.should eq(2)
      end

      it "only adds one instance of a folder" do
        directory = Fargo::Directory.new('a_dup_folder')
        directory = Fargo::Directory.new('a_dup_folder')
        Fargo::Directory.structure.count.should eq(2)
      end
    end

    context "modify files" do
      it "add a file to the root folder" do
        file = Fargo::Directory.new("new_file.rb", true)
        file.file?.should be_true
        Fargo::Directory.structure.count.should eq(2)
      end

      it "file can't be added to a non-existent folder" do
        expect do
          Fargo::Directory.new("non_existant_folder/new_file.rb", true)
        end.to raise_error(Errno::ENOENT)
      end

      context "moving and renaming files" do
        let(:folder) { Fargo::Directory.new("folder") }
        let!(:file) { Fargo::Directory.new("#{folder.path}/new_file.rb", true) }

        it "rename an existing file" do
          file.rename_path! "folder/renamed_file.rb"
          file.path.should eq("folder/renamed_file.rb")
        end

        it "removes a file" do
          structure_count = Fargo::Directory.structure.count
          file.remove_from_structure!
          Fargo::Directory.structure.count.should eq(structure_count - 1)
        end

        it "remove a folder and sub-folder/files" do
          folder.remove_from_structure!
          Fargo::Directory.structure.count.should eq(1)
        end

      end

      # it "remove an existing file"
    end

    context "find folders and files" do
      let!(:directory) { Fargo::Directory.new('existing_folder') }

      it "find an existing folder in the structure" do
        Fargo::Directory.find('existing_folder').path.should eq('existing_folder')
      end

      it "does not return a folder if folder not found" do
        Fargo::Directory.find('non_existing_folder').should be_nil
      end
    end

  end

end

# "/"
# "/folder"
# "/folder/file"
# "/folder/another/file"
# "/folder/another/directory/file"

# ["folder"]
# ["folder", "file"]
# ["folder", "another", "file"]
# ["folder", "another", "directory", "file"]


