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
  
  get '/:dir' do
    path = "#{root}/#{params[:dir]}"
    
    #check for thumbnails and make them if they don't exist; morgrify is a part of imagemagick
    unless File.directory? "#{path}/thumbnails"
      `mkdir #{path}/thumbnails && cd #{path} && mogrify -format png -path thumbnails -auto-orient -thumbnail 100x100 '*.jpg'`
    end
    
    #get the images in a usable array
    Dir.chdir path
    images = Dir["*.jpg", "*.png"]
    
    #do the same for thumbnails
    Dir.chdir "#{path}/thumbnails"
    thumbnails = Dir["*.jpg", "*.png"]
    
    array_string="['#{images.join('\',\'')}']"
    
    haml :gallery, :locals => {:images => images, :dir => dir, :array_string => array_string} 
  end
end