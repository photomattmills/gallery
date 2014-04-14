module Better
  class Directory
    require 'json'
    attr_accessor :path, :root, :params

    def initialize(root, params)
      @path = params[:path] ? (root + "/" + params[:path]) : root
      @root = root
      @params = params
    end

    def locals
      {
        :images => images,
        :image => params[:image] ? params[:image] : images.first,
        :image_index => image_index,
        :url => "http://photomattmills.com/images/#{params[:path]}/",
        :thumbnails => thumbnails,
        :folders => folders,
        :current_folder => params[:path]
      }
    end

    def images
      @images ||= get_images(path)
    end

    def get_images(dir_path=nil)
      Dir.chdir "#{dir_path}"
      @images = Dir["*.jpg", "*.png"].sort!
    end

    def thumbnails
      check_thumbnails
      get_images "#{path}/thumbnails"
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
