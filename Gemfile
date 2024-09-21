source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"
gem 'faraday'                  # HTTP client library
gem 'bcrypt', '~> 3.1.7'       # Password hashing for authentication
gem 'jsonapi-serializer'       # JSON:API serializer, optional
gem 'pry-byebug'               # Adds 'binding.pry' for debugging
group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails'            # Testing framework
  gem 'capybara'               # Integration testing tool
  gem 'factory_bot_rails'      # Test data generation
  gem 'faker'                  # Fake data generation
  gem 'shoulda-matchers'       # Provides RSpec with common Rails-specific matchers
  gem 'orderly'                # Tests order of elements in RSpec
  gem 'launchy'                # Opens URLs and files from Ruby, useful with Capybara
  gem 'webmock'                # Stubs HTTP requests in tests
  gem 'vcr'                    # Records HTTP interactions to replay in tests
  gem 'simplecov', require: false # Code coverage analysis tool
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

