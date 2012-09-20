require 'spec_helper'
require 'net/ftp'
require './spec/testing/server'

describe Fargo do
  let!(:connection) { ::Net::FTP.open("localhost") }

  it { connection.should_not be_closed }

  describe "#close" do
    it "should close an open connection" do
      connection.should_not be_closed
      connection.close
      connection.should be_closed
    end
  end

  context "open connection" do
    describe "#status" do
      it "should should be code 225" do
        connection.status.should include("225")
      end
    end

    describe "#login" do
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
    describe "#getdir" do
      it "should get the pwd" do
        connection.getdir.should eq("/")
      end
    end

    describe "#mkdir" do
      it "should make the directory" do
        connection.mkdir("tmp").should eq("tmp")
      end
    end

    describe "#chdir" do
      it "should change the directory" do
        connection.should_receive(:find_directory_path)
          .with("tmp").and_return("tmp")

        connection.chdir("tmp")
        connection.getdir.should eq("/tmp")
      end

      it "doesn't find the directory" do
        connection.should_receive(:find_directory_path)
          .and_raise(Net::FTPPermError)

        lambda { connection.chdir("no_dir_tmp") }
          .should raise_error(Net::FTPPermError)
      end
    end
  end

  describe "#puttextfile" do
    it "returns success messages" do
      connection.puttextfile('local/usr/home/textfile.rb', 'new_textfile.rb')
        .should == "200 OK, Data received."
    end
  end

  describe "#putbinaryfile" do
    it "returns success messages" do
      connection.putbinaryfile('local/usr/home/binaryfile.gz', 'new_binaryfile.gz')
        .should == "200 OK, Data received."
    end
  end

  describe "#getbinaryfile" do
    it "returns a fargo directory object" do
      file = Fargo::Directory.new("binaryfile.gz")
      connection.should_receive(:find_file)
        .with("remote/binaryfile.gz").and_return(file)

      connection.getbinaryfile('remote/binaryfile.gz', 'binaryfile.gz')
        .should == file
    end

    it "returns an error message when not found" do
      connection.getbinaryfile('/binaryfile.gz', 'binaryfile.gz')
        .should == "550 Requested action not taken. File unavailable"
    end
  end

  describe "#gettextfile" do
    it "returns a fargo directory object" do
      file = Fargo::Directory.new("textfile.txt")
      connection.should_receive(:find_file)
        .with("remote/textfile.txt").and_return(file)

      connection.gettextfile('remote/textfile.txt', 'textfile.txt')
        .should == file
    end

    it "returns an error message when not found" do
      connection.gettextfile('/textfile.txt', 'textfile.txt')
        .should == "550 Requested action not taken. File unavailable"
    end
  end
end
