require 'spec_helper'

describe Better::Directory do
  context "With a root dir, but without a gallery dir" do
    let(:superdir) { Better::Directory.new(File.dirname(__FILE__), {path: nil, image: nil}) }
    
    describe "#initialize" do
      it "sets the path to root" do
        superdir.path.should == File.dirname(__FILE__)
      end
      
      it "gets all the images" do
        superdir.images.should == ["0001.jpg"]
      end
    end
      
    describe "#thumbnails" do
      it "lists the thumbnails properly" do
        superdir.thumbnails.should == ["0001.png"]
      end
    end
    
    describe "#folders" do
      it "gets all the subdirectories" do
        superdir.folders.should eq ["flynn-curran-wedding", "thumbnails"]
      end
    end
  end
  
  context "With a root dir and a gallery dir" do
    let(:superdir) { Better::Directory.new(File.dirname(__FILE__), {path: "flynn-curran-wedding", image: nil}) }
    
    describe "#initialize" do
      it "sets the path to path" do
        superdir.path.should == File.dirname(__FILE__) + "/flynn-curran-wedding"
      end
      
      it "gets all the images" do
        superdir.images.should == ["0001.jpg", "0002.jpg", "0003.jpg", "0004.jpg", "0005.jpg", "0006.jpg", "0007.jpg", "0008.jpg"]
      end
    end
    
    describe "#folders" do
      it "doesn't get subdirectories" do
        superdir.folders.should be_nil
      end
    end
  end
end