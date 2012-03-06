require 'sinatra'
require 'haml'
root="/users/matt/Desktop"
get '/' do
  dir_list = Dir.entries("/home/matt/public_html/images")
  haml :index, :format => :html5, :locals => {:images => dir_list.map{|thing| return thing unless thing.directory?}}
end

get '/:dir' do
  dir=params[:dir]
  images= Dir.entries("#{root}/#{dir}").map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{dir}/#{thing}")}.compact!
  haml :layout, :locals => {:images => images, :dir => dir} 
end
