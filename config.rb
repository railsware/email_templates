###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

activate :directory_indexes

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

module PreMailer
  class << self
    def registered(app)
      require 'premailer'
      app.after_build do |builder|
        prefix = build_dir + File::SEPARATOR
        Dir.chdir(build_dir) do
          Dir.glob('**/*.html') do |file|
            premailer = Premailer.new(file, warn_level: Premailer::Warnings::SAFE, adapter: :nokogiri, preserve_styles: false, remove_classes: true, remove_comments: true, remove_ids: true, remove_scripts: true, include_link_tags: true, include_style_tags: true)
            fileout = File.open(file, "w")
            fileout.puts premailer.to_inline_css
            fileout.close
            premailer.warnings.each do |w|
              builder.say_status :premailer, "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
            end
            builder.say_status :premailer, prefix+file
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
