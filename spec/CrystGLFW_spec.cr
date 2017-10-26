require "./spec_helper"

describe CrystGLFW do

  describe "#version" do
    it "returns a NamedTuple(major: Int32, minor: Int32, rev: Int32)" do
      CrystGLFW.version.should be_a(NamedTuple(major: Int32, minor: Int32, rev: Int32))
    end

    it "can be called outside of a run block" do
      CrystGLFW.version.should be_a(NamedTuple(major: Int32, minor: Int32, rev: Int32))
    end
  end

  describe "#version_string" do
    it "returns a String" do
      CrystGLFW.version_string.should be_a(String)
    end

    it "can be called outside of a run block" do
      CrystGLFW.version_string.should be_a(String)
    end
  end

  describe "#time" do
    context "when GLFW is initialized" do 
      it "returns a Float64" do
        CrystGLFW.run do
          CrystGLFW.time.should be_a(Float64)
        end
      end
    end
    context "when GLFW is not initialized" do
      it "raises an exception" do
        expect_raises do
          CrystGLFW.time
        end
      end
    end
  end

end
