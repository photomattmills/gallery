require 'sinatra/base'
require 'sinatra'
require 'haml'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

#This is a workaround for a sinatra/unicorn bug. setting the views with an absolute path fixes it.
WORKING_FOLDER = Dir.pwd

class Gallery < Sinatra::Base

  post "/sns" do
    File.open("/tmp/snsrequest", "w"){ |f| f.write request.body }
  end

  get '/?:path?/?:image?' do
    @dir = Better::Directory.new("/home/matt/public_html/images", params )

    begin
      haml :index, :views => "#{WORKING_FOLDER}/views", :locals => @dir.locals
    rescue
      raise Sinatra::NotFound
    end
  end

  not_found do
    'Nothing to see here.'
  end
end
