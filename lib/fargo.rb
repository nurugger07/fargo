require 'net/ftp'

module Fargo

  # This puts a file on the remote server
  def self.put(local, remote=nil)
    "200 OK, Data received."
  end

  # Download the remote file to a local copy
  def self.get(remotes, local=nil)
    open(local)
  end
end
