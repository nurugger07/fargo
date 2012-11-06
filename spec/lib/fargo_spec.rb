require 'spec_helper'
require 'fargo'

describe Fargo do
  describe ".put" do
    it "uploads a single file and returns a 200" do
      Fargo.put("/local/file.rb", "/remote/file.rb")
        .should == "200 OK, Data received."
    end
  end

  describe ".get" do
    it "downloads a single file" do
      Fargo.get("/remote/file.rb", "/local/file.rb")
        .should == []
    end
  end
end
