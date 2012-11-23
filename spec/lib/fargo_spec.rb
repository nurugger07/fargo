require 'spec_helper'
require 'fargo'

describe Fargo do
  describe ".put" do
    it "uploads a single file and returns a 200" do
      Fargo.put("/fixtures/file.txt", "/remote/file.txt")
        .should == "200 OK, Data received."
    end
  end

  describe ".get" do
    it "downloads a single file" do
      Fargo.get("/remote/file.txt", "spec/fixtures/file.txt")
        .path.should eq("spec/fixtures/file.txt")
    end
  end
end
