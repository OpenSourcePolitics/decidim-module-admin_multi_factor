# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "~> 0.29.3"
gem "decidim-core", "~> 0.29.3"

gem "graphql", "~> 2.0"
gem "graphql-docs", "~> 4.0"

gem "decidim-admin_multi_factor", path: "./"

gem "bootsnap", "~> 1.3"

group :development, :test do
  gem "decidim-dev", "~> 0.29.3"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 4.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end

group :test do
  gem "rubocop-faker"
  gem "rubocop-rspec"
end
