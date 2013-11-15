module Better
  class Directory
    require 'json'
    attr_accessor :path, :images, :root, :params

    def initialize(root, params)
      @path = params[:path] ? (root + "/" + params[:path]) : root
      @root = root
      @params = params
      images
    end

    def images
      @images ||= get_images
    end

    def get_images(dir_path=nil)
      real_path = dir_path ? (root + "/" + dir_path) : @path
      Dir.chdir "#{real_path}"
      Dir["*.jpg", "*.png"].sort!
    end
    
    def thumbnails
      check_thumbnails
      get_images "#{params[:path]}/thumbnails"
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
    
    def folders
      unless params[:path]
        Dir.chdir root
        Dir["*"].map {|file| file if File.directory? file}.compact
      end
    end
  end
end