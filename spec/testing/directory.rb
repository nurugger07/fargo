module Fargo
  class Directory

    def self.root(root_path, &block)
      begin
        new(root_path, &block)
      ensure
        @structure = nil
      end
    end

    def find(path)
      structure[clean_path(path)]
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

      Fargo::Directory.structures[@path] = self
    end

    def basename
      @path.split('/').last
    end

    def file?
      !!@file
    end

    def folder?
      @file == false
    end
  end
end
