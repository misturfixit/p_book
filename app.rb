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
  session[:r] = session[:r]
  session[:r].class
  wbinfo = {
    host:ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DATABASE'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']
  }
  wb = PG::Connection.new(wbinfo)
  wb.exec "DROP TABLE IF EXISTS pb"
  wb.exec "CREATE TABLE pb (First KEY, Last KEY,
   	Street KEY,
    City Key, 
    State KEY, 
    ZIP KEY, 
    Phone KEY)"
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
    list = "%s %s %s" % [row['First'], row['Last'], row['Street'], row['City'], row['State'], row['Zip'], row['Phone']]
end
rescue PG::Error => e
	puts e.message

ensure 
	rs.clear if rs
	wb.close if wb
end
erb :, locals:{list:list}
end


