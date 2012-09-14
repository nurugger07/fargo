require 'spec_helper'
require 'net/ftp'
require './spec/testing/server'

describe Fargo do
  describe "#open" do
    it "should open connection" do
      connection = ::Net::FTP.open("localhost")
      connection.should_not be_closed
    end
  end

  describe ".close" do
    it "should close an open connection" do
      connection = ::Net::FTP.open("localhost")
      connection.should_not be_closed
      connection.close
      connection.should be_closed
    end
  end

  context "open connection" do
    let!(:connection) { ::Net::FTP.open("localhost") }

    describe ".status" do
      it "should should be code 225" do
        connection.status.should include("225")
      end
    end

    describe ".login" do
      it "should login to server" do
        connection.login("joe@example", "password")
        connection.status.should include("230")
      end

      it "attempt anonymous login should fail" do
        connection.login
        connection.status.should include("332")
      end

      it "attempt without password should fail" do
        connection.login("joe@example.com")
        connection.status.should include("430")
      end
    end

  end

  context "navigate directory structures" do
    let!(:connection) { ::Net::FTP.open("localhost") }

    describe ".getdir" do
      it "should get the pwd" do
        connection.getdir.should eq("/")
      end
    end

    describe ".mkdir" do
      it "should make the directory" do
        connection.mkdir("tmp").should eq("tmp")
      end
    end

    describe ".chdir" do
      it "should change the directory" do
        connection.chdir("tmp")
        connection.getdir.should eq("/tmp")
      end
    end

    it "makes a directory and then change into it" do
      connection.mkdir("new_tmp")
      connection.chdir("new_tmp")
      connection.getdir.should eq("/new_tmp")
    end

    it "raises an error if the directory doesn't exist" do
      connection.chdir("no_dir_tmp").should raise_error(Net::FTPReplyError)
    end
  end
end
