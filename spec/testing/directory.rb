module Fargo
  class Directory

    def self.set_root(root_path, &block)
      @structure = nil
      new(root_path, &block)
    end

    def find(path)
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

      Fargo::Directory.structure[@path] = self
    end

    def basename
      @path.split('/').last || ".."
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
  end
end
