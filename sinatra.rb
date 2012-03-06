require 'sinatra/base'
require 'sinatra'
require 'haml'
class Gallery < Sinatra::Base
  root="/home/matt/public_html/images"
  get '/' do
    images = Dir.entries(root).map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{thing}")}.compact!
    images = images.map {|name| name if name.match(/(^.+\.jpg|^.+\.png)/)}.compact.sort
    haml :index, :format => :html5, :locals => {:images => images, :dir => ""}
  end
  
  get '/:dir' do
    dir = params[:dir]
    images = Dir.entries("#{root}/#{dir}").map{|thing| thing unless thing.match(/^\./) || File.directory?("#{root}/#{dir}/#{thing}")}.compact!
    images = images.map {|name| name if name.match(/(^.+\.jpg|^.+\.png)/)}.compact.sort
    array_string="['#{images.join('\',\'')}']"
    haml :layout, :locals => {:images => images, :dir => dir, :array_string => array_string} 
  end
end