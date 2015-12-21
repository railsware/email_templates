activate :directory_indexes

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

module PreMailer
  class << self
    def registered(app)
      require 'premailer'

      app.after_build do |builder|
        prefix = "#{build_dir}#{File::SEPARATOR}"
        Dir.chdir(build_dir) do
          Dir.glob('**/*.html') do |file|

            premailer = Premailer.new(file, warn_level: Premailer::Warnings::SAFE, adapter: :nokogiri, preserve_styles: false, remove_scripts: true, include_link_tags: true, include_style_tags: true)
            File.open(file, "w") do |f|
              f.write(premailer.to_inline_css)
            end

            premailer.warnings.each do |w|
              builder.say_status :premailer, "[#{w[:level]}] #{w[:message]} may not render properly in #{w[:clients]}"
            end
            builder.say_status :premailer, "#{prefix}#{file}"
          end
        end
      end
    end
    alias :included :registered
  end
end

::Middleman::Extensions.register(:inline_premailer, PreMailer)

activate :inline_premailer

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # min html
  #activate :minify_html

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
