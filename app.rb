require "sinatra"
require 'aws-sdk'
require 'pg'
require_relative "funk.rb"
load './local_env.rb'
enable 'sessions'
get '/' do
erb :root
end
post '/records' do
  session[:data] = session[:data]
  session[:data].class
  wbinfo = {
    host:ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DATABASE'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']
  }
  wb = PG::Connection.new(wbinfo)

  wb.exec "CREATE TABLE pb (
  	id int primary key,
  	 fname varchar(50),
     lname varchar(50),
     addr varchar(50),
     city varchar(25),
     state varchar(2),
     zip varchar(5),
     phone varchar(10))"

  wb.exec "INSERT into pb VALUES(session[:r])"
  redirect '/get'
end
get '/get_nfo' do
  wbinfo = {
    host:ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DATABASE'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']
  }
  wb = PG::Connection.new(wbinfo)
  rs = wb.exec 'SELECT * FROM pb LIMIT 7'
  	list = []
  		rs.each do |row|
    list = "%s %s %s" % 
      [row['First'],
      row['Last'], 
      row['Street'], 
      row['City'],
      row['State'], 
      row['Zip'],
      row['Phone']]
			end
end
	rescue PG::Error => e
		puts e.message
	end
ensure 
	rs.clear if rs
	wb.close if wb


erb :return, locals:{list:list}
end


