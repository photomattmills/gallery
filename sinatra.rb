# this is 

require 'sinatra/base'
require 'sinatra'
require 'haml'
class Gallery < Sinatra::Base
  root="/home/matt/public_html/images"
  
  get '/' do
    images = Dir.entries(root).map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{thing}")}.compact! rescue []
    images = images.map {|name| name if name.match(/(^.+\.jpg|^.+\.png)/)}.compact.sort
    haml :index, :locals => {:images => images, :dir => "", :array_string => ""}
  end
  
  get '/:dir/?:image?' do
    img_path = "#{root}/#{params[:dir]}"
      
    check_thumbnails img_path
    
    images = get_images(img_path)
    
    thumbnails = get_images("#{img_path}/thumbnails")
    
    if params[:image]
      image_index = params[:image]
    else
      image_index = 0
    end
    
    array_string="['#{images.join('\',\'')}']"
    
    haml :gallery, :locals => {:images => images, :image_index => image_index, :dir => params[:dir], :array_string => array_string} 
  end

  def get_images(path)
   Dir.chdir "#{path}"
   return Dir["*.jpg", "*.png"]
  end
  
  def check_thumbnails(img_path)
    #check for thumbnails and make them if they don't exist; morgrify is a part of imagemagick; 
    # see http://www.imagemagick.org/Usage/thumbnails/ for details etc
    unless File.directory? "#{img_path}/thumbnails"
      `mkdir #{img_path}/thumbnails && cd #{img_path} && mogrify -format png -path thumbnails -auto-orient -thumbnail 100x100 '*.jpg'`
    end
  end
end