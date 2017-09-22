require 'pg'
	load './local_env.rb' if File.exist?('./local_env.rb')
###############
def makedabase()
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
					ID bigserial NOT NULL,
          f_name text,
          l_name text,
          street text,
          city text,
          state text,
          zip text,
          phone text)");
	rescue PG::Error => e
	   puts e.message
	ensure
	   pb.close if pb
	end
end	

##################################
def add_entry(data)
 
  pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  db = PG::Connection.new(pbinfo)
  db.exec("INSERT INTO pb(f_name,l_name,street,city,state,zip,phone)VALUES('#{data[0]}','#{data[1]}','#{data[2]}','#{data[3]}','#{data[4]}','#{data[5]}','#{data[6]}')");
	#db.exec ("INSERT INTO public.pb(f_name,l_name,street,city,state,zip, phone)VALUES('jenny','jenny','ezee st','anything','aaannnddthen','hereitis','thereitis')");
end		
