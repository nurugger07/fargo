module Fargo
  class Directory

    def self.set_root(root_path, &block)
      @structure = nil
      new(root_path, &block)
    end

    def self.find(path)
      Fargo::Directory.structure[Fargo::Directory::clean_path(path)]
    end

    def self.structure
      @structure ||= {}
    end

    def self.clean_path(path)
      path.chomp('/')
    end

    def initialize(path, file = false, mtime = Time.now)
      @path    = Fargo::Directory::clean_path(path)
      @mtime   = mtime
      @file    = file

      unless basepath.empty?
        unless Fargo::Directory.find(basepath)
          raise Errno::ENOENT
        end
      end

      add_to_structure
    end

    def add_to_structure
      Fargo::Directory.structure[@path] = self
    end

    def remove_from_structure!
      Fargo::Directory.structure.map do |key, file|
        unless file.root?
          if file.path.spilt("/")[path_index] == basename
            Fargo::Directory.structure.delete(path)
          end
        end
      end
    end

    def path_index
      path.split("/").find_index(basename)
    end

    def basepath
      path.split("/")[0...-1].join('/')
    end

    def basename
      @path.split("/").last || ".."
    end

    def rename_path!(new_path)
      remove_from_structure!
      @path = new_path
      add_to_structure
    end

    def path
      @path
    end

    def file?
      !!@file
    end

    def folder?
      @file == false
    end

    def root?
      @path == "/"
    end
  end
end

# "/"
# "/file.rb"
# "/new_folder/file.rb"
# "/new_folder/another_folder"
# "/new_folder/another_folder/file.rb"
# "/new_folder/another_folder/file2.rb"
