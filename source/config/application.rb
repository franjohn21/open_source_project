require 'pathname'
require 'sqlite3'
require 'active_record'
require 'logger'
require 'faker'
require 'yelp'
require 'google_directions'

APP_ROOT = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))

APP_NAME = APP_ROOT.basename.to_s

DB_PATH  = APP_ROOT.join('db', APP_NAME + ".db").to_s

if ENV['DEBUG']
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

# Automatically load every file in APP_ROOT/app/models/*.rb, e.g.,
#   autoload "Person", 'app/models/person.rb'
#
# See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html

Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

Dir[APP_ROOT.join('app', 'views', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

ActiveRecord::Base.establish_connection :adapter  => 'sqlite3',
                                        :database => DB_PATH

$yelp = Yelp::Client.new({ consumer_key: 'ABHseWQ2ikV5ke6mpU-6-A',
                           consumer_secret: '2EFEJD4UYc2k9D_nhfUZU3BYszA',
                           token: 'U8l06FytOYvxYf68d-EFPl-L7buOKTEa',
                           token_secret: 'vWr4aIV3iwgib9F9mrTHKFTob_E'
                        })

GOOGLE_MAPS_API_KEY = 'AIzaSyA-MMwBr12H47ZO5Ih1NndUywirmMID3FE'
