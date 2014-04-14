require 'spec_helper'

describe Better::Directory do
  context "With a root dir, but without a gallery dir" do
    let(:superdir) { Better::Directory.new(File.dirname(__FILE__), {path: nil, image: nil}) }

    describe "#locals" do
      let(:expected){
        {
          :images=>["0001.jpg"],
          :image=>"0001.jpg",
          :image_index=>0,
          :url=>"http://photomattmills.com/images//",
          :thumbnails=>["0001.png"],
          :folders=>["flynn-curran-wedding", "thumbnails"],
          :current_folder => nil
        }
      }

      it "gets the right locals" do
        superdir.locals.should == expected
      end
    end
  end

  context "With a root dir and a gallery dir" do
    let(:superdir) { Better::Directory.new(File.dirname(__FILE__), {path: "flynn-curran-wedding", image: nil}) }


    describe "#locals" do
      let(:expected){
        {
          :images=>["0001.jpg", "0002.jpg", "0003.jpg", "0004.jpg", "0005.jpg", "0006.jpg", "0007.jpg", "0008.jpg"],
          :image=>"0001.jpg",
          :image_index=>0,
          :url=>"http://photomattmills.com/images/flynn-curran-wedding/",
          :thumbnails=>["0001.png", "0002.png", "0003.png", "0004.png", "0005.png", "0006.png", "0007.png", "0008.png"],
          :folders=>nil,
          :current_folder=>"flynn-curran-wedding"
        }
      }

      it "gets the right locals" do
        superdir.locals.should == expected
      end
    end
  end
end
