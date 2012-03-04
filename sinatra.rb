require 'sinatra'
require 'haml'

BASE_DIR="/home/matt/public_html/images/"
layout=File.open('layout.haml','r').read
dir_list = Dir.entries BASE_DIR


get '/'
  haml :index, :format => :html5
end

dir_list = Dir.entries BASE_DIR