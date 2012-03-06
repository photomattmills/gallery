require 'sinatra/base'
require 'sinatra'
require 'haml'
class Gallery < Sinatra::Base
  root="/home/matt/public_html/images"
  get '/' do
    dir_list = Dir.entries("/home/matt/public_html/images").map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{dir}/#{thing}")}.compact!
    haml :index, :format => :html5, :locals => {:images => dir_list}
  end
  
  get '/:dir' do
    dir=params[:dir]
    images= Dir.entries("#{root}/#{dir}").map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{dir}/#{thing}")}.compact!
    haml :layout, :locals => {:images => images, :dir => dir} 
  end
end