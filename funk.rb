require 'pg'
	load './local_env.rb' if File.exist?('./local_env.rb')

begin
  pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  	#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#
pb = PG::Connection.new(pbinfo)
pb.exec ("CREATE TABLE public.pb (
					Id int primary key,
          F_name varchar(50),
          L_name varchar(50),
          Street varchar(50),
          City varchar(25),
          State varchar(25),
          Zip varchar(5),
          Phone varchar(10))");
			#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#
	pb.exec ("INSERT INTO public.pb (
						id,
				    F_name, L_name, 
				    Street, City,
			   	  State, Zip, Phone)
		  VALUES('#{data[0]}',
	   '#{data[1]}', '#{data[2]}', 
	   '#{data[3]}', '#{data[4]}', 
	   '#{data[5]}', '#{data[6]}')");
		  #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#
rescue PG::Error => e
	   puts e.message
ensure
	   pb.close if pb
	end