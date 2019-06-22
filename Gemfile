source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails',        '~> 5.2.3'
#gem 'sqlite3'↓
gem 'mysql2'
gem 'puma',         '~> 3.11'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks',   '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder',     '~> 2.5'
gem 'bootsnap',     '>= 1.1.0', require: false
gem 'faker',        '~> 1.9.3'
gem 'carrierwave',  '~> 1.2.2'
gem 'mini_magick',  '~> 4.7.0'

# 20190525 add
gem 'jquery-rails', '~> 4.3.0'
# 20190527 add
gem 'bootstrap',    '~> 4.1.1'
# 20190601 add
gem 'bcrypt',       '~> 3.1.12'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen',       '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # 20190525 add
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
