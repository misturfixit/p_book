require 'pg'
# require 'bcrypt'
	load './local_env.rb' if File.exist?('./local_env.rb')
###############
def makedatable()
	begin
	  pbinfo = {
	    host: ENV['RDS_HOST'],
	    port: ENV['RDS_PORT'],
	    dbname: ENV['RDS_DB_NAME'],
	    user: ENV['RDS_USERNAME'],
	    password: ENV['RDS_PASSWORD']
  	}
db = PG::Connection.new(pbinfo)
db.exec ("CREATE TABLE public.pb (
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
	   db.close if db
	end
end	
##################################################################
def makelogintable()
    pbinfo = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
    }
db = PG::Connection.new(pbinfo)
db.exec ("CREATE TABLE public.login (
          ID bigserial NOT NULL,
          u_name text,
          p_word text)");
  rescue PG::Error => e
     puts e.message
  ensure
     db.close if db
  end
end 

##################################################################
def authourize(u_name, p_word)
   pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  db = PG::Connection.new(pbinfo)
  auth = db.exec("SELECT * FROM public.login WHERE u_name = '#{u_name}'")
    if auth.num_tuples.zero? == false
      whodat = auth.values
        whodat.each_pair do |u_name, p_word| 
          if u_name == u_name && p_word == p_word
             msg = "Logging On"
          elsif u_name == u_name
            msg = "Wrong Password"
          elsif p_word == p_word
            msg = "Wrong Username"
      end 
    end
      msg = "Wrong Username and Password" 
  end

    else 
        message = "Don't know ya" 
    end     
  whodat
end 

##################################################################
###################################################################
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
######################################################################
def searcher(nmbr)
   pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  db = PG::Connection.new(pbinfo)
  look = db.exec("SELECT * FROM public.pb WHERE phone = '#{nmbr}'")
    if look.num_tuples.zero? == false
        result =  look.values
    else 
        result = "Never Heardof'em" 
    end     
  result
end 
###############################################################
###############################################################
###############################################################