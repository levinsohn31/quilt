require 'aws/s3'

AWS_ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']

namespace :providerimages do
	desc "Resize provider images for lo-res displays"
	task :resize, :provider do |t, args|
		args.with_defaults( :provider => "*" )
		@provider = args.provider

		# Directory of provider images to process
		@dir = "#{Rails.root.to_s}/app/assets/images/icons/janrain-providers"

		# All sizes to generate
		@generate_sizes = [48,32,24,16]

		# Make sure directories exist before saving into them
		@generate_sizes.each do |size|
			Dir.mkdir("#{@dir}/#{size}") unless File.exists?("#{@dir}/#{size}")
		end

		Dir["#{@dir}/#{@provider}.png"].each do |file|
			@generate_sizes.each do |newsize|
				filename = File.basename(file)
				`convert "#{file}" -resize #{newsize}x#{newsize} \
					-channel A -level 20,100%,0.85 +channel \
					-background black -alpha background \
					"#{@dir}/#{newsize}/#{filename}"`
			end
		end
	end
end

namespace :assets do
   desc "Deploy Quilt assets to S3/Cloudfront"
   task :deploy, [:release_type] => :environment do |t, args|
      args.with_defaults(:release_type => 'development')

      if args[:release_type]  == 'development'
         AWS_BUCKET = 'janrain.ui'
         puts '== QUILT DEVELOPMENT RELEASE'
      elsif args[:release_type] == 'production'
         AWS_BUCKET = 'janrain.quilt'
         puts '== QUILT PRODUCTION RELEASE'
      end

      puts "== Compiling Quilt #{Quilt::VERSION} assets"
      Rake::Task['assets:clean'].invoke
      Rake::Task['assets:precompile'].invoke

      puts "== Uploading Quilt #{Quilt::VERSION} assets to S3/Cloudfront"
      AWS::S3::Base.establish_connection!(
      :access_key_id     => AWS_ACCESS_KEY_ID,
      :secret_access_key => AWS_SECRET_ACCESS_KEY
      )
      service = AWS::S3::Service.new(
      :access_key_id => AWS_ACCESS_KEY_ID,
      :secret_access_key => AWS_SECRET_ACCESS_KEY)
      bucket = AWS::S3::Bucket.find(AWS_BUCKET)

      path = "#{Rails.root.to_s}/public/#{Quilt::VERSION}"

      STDOUT.sync = true

      Dir.glob("#{path}/**/**").each do |file|

         # If a gzipped version of the current file exists, skip this one
         # and serve the gzipped version instead
         if File.file?("#{file}.gz")
            next
         end

         if File.file?(file)

            s3_file = file.gsub("#{path}", "#{Quilt::VERSION}")

            ext = File.extname(file)

            # Set Content-Encoding header for .gz files
            if ext == ".gz"
               encoding = 'gzip'
               s3_file = s3_file.gsub( ".gz", "" )
               ext = File.extname( File.basename(file, '.gz') )
            end

            begin
               s3_file_exists = bucket[s3_file]
            rescue
               s3_file_exists = nil
            end

            if !s3_file_exists
               puts "Uploading: #{s3_file}"

               # Set Content-Type if file type is recognized
               case ext
               when ".woff"
                  type = "application/x-font-woff"
               when ".ttf"
                  type = "font/ttf"
               when ".eot"
                  type = "font/eot"
               when ".otf"
                  type = "font/otf"
               when ".css"
                  type = "text/css"
               when ".js"
                  type = "application/javascript"
               when ".png"
                  type = "image/png"
               end

               options = {
                  :access => :public_read,
                  :cache_control => "public, max-age=31557600",
                  :expires => CGI.rfc1123_date(Time.now + 1.year)
               }

               if type
                  options[ :content_type ] = type
               end

               if encoding
                  options[ :content_encoding ] = encoding
               end

               AWS::S3::S3Object.store(s3_file, open(file), AWS_BUCKET, options)
            else
               puts "File Already Exists: #{s3_file}"
            end
         end
      end

      STDOUT.sync = false
      puts "== Done uploading Quilt assets"

      puts "== Removing the generated Quilt assets"
      Rake::Task['assets:clean'].invoke
   end
end
