configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  set :database, {
    adapter: "sqlite3",
    database: "db/db.sqlite3"
  }

  # ActiveRecord::Base.establish_connection(
  #   adapter: 'postgresql',
  #   encoding: 'unicode',
  #   pool: 5,
  #   database: ENV['DATABASE_URL']
  #   #commandline#  export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/DATABASENAME"
  #   # 
  #   # postgres://user3123:passkja83kd8@ec2-117-21-174-214.compute-1.amazonaws.com:6212/db982398
  #   # username: 'grbgfwsfqekubn',
  #   # password: 'XzDPWg08iWbQNOj4DduZtgMyG2',
  #   # host: 'ec2-184-73-165-193.compute-1.amazonaws.com',
  #   # port: 5432,
  #   # min_messages: 'error'
  # )


  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
