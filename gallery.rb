require 'sinatra/base'
require 'sinatra'
require 'haml'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

#This is a workaround for a sinatra/unicorn bug. setting the views with an absolute path fixes it.
WORKING_FOLDER = Dir.pwd

class Gallery < Sinatra::Base
  get '/?:path?/?:image?' do
    @dir = Better::Directory.new("/home/matt/public_html/images", params )  
    
    locals = {
      :images => @dir.images,
      :image => @dir.images.first,
      :image_index => @dir.image_index, 
      :url => "http://photomattmills.com/images/#{params[:path]}/",
      :array => @dir.to_json,
      :thumbnails => @dir.thumbnails,
      :folders => @dir.folders,
      :path => params[:path]
      }
    
    haml :index, :views => "#{WORKING_FOLDER}/views", :locals => locals
  end
end