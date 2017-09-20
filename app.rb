require 'sinatra'
require 'aws-sdk'
require 'pg'
load './local_env.rb'
enable 'sessions'

get '/' do
	erb :input
end

post '/get_nfo' do
  data = params[:data]
begin

  pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }

pb = PG::Connection.new(pbinfo)

pb.exec ("CREATE TABLE public.pb (
					Id int primary key,
          F_name varchar(50),
          L_name varchar(50),
          Street varchar(50),
          City varchar(25),
          State varchar(2),
          Zip varchar(5),
          Phone varchar(10))")

pb.exec ("INSERT INTO public.pb (
					id,
			    F_name, L_name, 
			    Street, City,
		   	  State, Zip, Phone)
	  VALUES('#{data[0]}',
   '#{data[1]}', '#{data[2]}', 
   '#{data[3]}', '#{data[4]}', 
   '#{data[5]}', '#{data[6]}')");
	  

	rescue PG::Error => e
    puts e.message
	ensure
    pb.close if pb
end
  redirect '/get'
end

get '/get' do
	begin
	  pbinfo = {
	    host: ENV['RDS_HOST'],
	    port:ENV['RDS_PORT'],
	    dbname:ENV['RDS_DB_NAME'],
	    user:ENV['RDS_USERNAME'],
	    password:ENV['RDS_PASSWORD']
	  }

	  pb = PG::Connection.new(pbinfo)
	  rs = pb.exec "SELECT * FROM pb LIMIT 7"

		  list = []
		  rs.each do |row|
		    list << [row['First'], 
				    row ['Last'], row['Street'],
				    row ['City'], row['State'], 
				    row ['Zip'], row['Phone']]
		  end

  #{}"%s %s %s %s %s %s %s" %

  rescue PG::Error => e

    puts e.message

  ensure
    rs.clear if rs
    pb.close if pb
end
# post '/' do
#   erb :return, locals:{list: list}
# end
end

