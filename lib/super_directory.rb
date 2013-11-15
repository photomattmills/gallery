module Better
  class Directory
    require 'json'
    attr_accessor :path, :images, :root, :params

    def initialize(root, params)
      @path = params[:path]
      @root = root
      @images = images(path)
      @params = params
    end

    def images(path)
      Dir.chdir "#{path}"
      Dir["*.jpg", "*.png"].sort!
    end
    
    def thumbnails
      check_thumbnails
      images "#{path}/thumbnails"
    end
    
    def to_json
      images.to_json
    end
    
    def image_index
      if params[:image]
        return images.index(params[:image])
      else
        return 0
      end
    end
    
    def check_thumbnails
      unless File.directory? "#{path}/thumbnails"
        `mkdir #{path}/thumbnails && cd #{path} && mogrify -format png -path thumbnails -auto-orient -thumbnail 100x100 '*.jpg'`
      end
    end
    
    def dirs
      unless params[:dir]
        Dir.chdir root
        Dir["*"].map {|file| file if File.directory? file}.compact
      end
    end
  end
end