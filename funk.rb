require 'pg'
#require 'bcrypt'
	load './local_env.rb' if File.exist?('./local_env.rb')
#############################################################
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
  begin
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
def authorize(u_n, p_w)
   pbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  db = PG::Connection.new(pbinfo)
  authusr = db.exec("SELECT * FROM public.login WHERE u_name = '#{u_n}'")
   if authusr.num_tuples.zero? == false
    val = authusr.values.flatten
     
      if val.include?(password) 
             redirect '/return'
         else
             msg = "Wrong Username"
      end
    else  
         msg = "Wrong Password" 
    end  
  db.close if db

    msg
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

       result = {:Never=>'Heard',:of=>'em'}##so....i'm pretty proud of this one
    end     
  db.close if db
 result

end 
	#
###############################################################
###############################################################
###############################################################