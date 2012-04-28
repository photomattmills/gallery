require 'sinatra/base'
require 'sinatra'
require 'haml'
#This is a workaround for a sinatra/unicorn bug. setting the views with an absolute path fixes it.
WORKING_FOLDER = Dir.pwd


class Gallery < Sinatra::Base
  root="/home/matt/public_html/images"
  
  get '/?*?.jpg?' do
    images = get_images(root)
    thumbnails = get_images("#{root}/thumbnails")
    Dir.chdir root
    folders = Dir["*"].map {|file| file if File.directory? file}.compact
    array_string="['#{images.join('\',\'')}']"
    
    unless params[:splat].first.empty?
      image_index = 0 #images.index(params[:splat].first)
      image = params[:splat].first
    else
      image_index = 0 
      image = images.first
    end
    
    locals = {
      :images => images, 
      :image_index => image_index, 
      :image => image,
      :dir => "", 
      :array_string => array_string, 
      :thumbnails => thumbnails,
      :folders => folders
      }
      
    haml :index, :views => "#{WORKING_FOLDER}/views", :locals => locals
  end
  
  get '/:dir/?:image?' do
    img_path = "#{root}/#{params[:dir]}"
      
    check_thumbnails img_path
    
    images = get_images(img_path)
    
    thumbnails = get_images("#{img_path}/thumbnails")
    
    if params[:image]
      image_index = images.index(params[:image])
      image = params[:image]
    else
      image_index = 0
      image = images.first
    end
    
    array_string="['#{images.join('\',\'')}']"
    
    locals = {
      :images => images, 
      :image_index => image_index, 
      :image => image, 
      :dir => params[:dir], 
      :array_string => array_string, 
      :thumbnails => thumbnails
      }
    
    haml :gallery, :views => "#{WORKING_FOLDER}/views", :locals => locals
  end

  def get_images(path)
   Dir.chdir "#{path}"
   return Dir["*.jpg", "*.png"]
  end
  
  def check_thumbnails(img_path)
    #check for thumbnails and make them if they don't exist; morgrify is a part of imagemagick; 
    #see http://www.imagemagick.org/Usage/thumbnails/ for details etc
    unless File.directory? "#{img_path}/thumbnails"
      `mkdir #{img_path}/thumbnails && cd #{img_path} && mogrify -format png -path thumbnails -auto-orient -thumbnail 100x100 '*.jpg'`
    end
  end
end