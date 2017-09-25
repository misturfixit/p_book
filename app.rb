require 'sinatra'
require 'pg'
require_relative 'funk.rb'
#require 'bcrypt'
enable 'sessions'
	load './local_env.rb' if File.exists?('./local_env.rb')
########################################
get '/' do
	msg = params[:msg] || ""

	erb :login, locals:{msg: msg}
end
#	erb :input
#############################################################
post '/login' do
	#makelogintable()
	u_n = params[:u_n]
	p_w = params[:p_w]
	  wbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }
  db = PG::Connection.new(wbinfo)
  authusr = db.exec("SELECT * FROM login WHERE u_name ='#{u_n}'")
  val = authusr.values.flatten
	  #hashed_password = BCrypt::Password.create "val[2]"
  if val.include?(p_w)
  	msg = "logging in"
      redirect '/get_nfo?msg='+msg
  else
  	msg = "invalid login"
      redirect '/?msg='+msg
  end
 #  authorize(u_n, p_w)
 #  msg = params[:msg] || ""
 #  	if msg == "Logging On"
	# redirect '/get_nfo?msg='+msg
	# 	else
	# redirect '/?msg='+msg
	# 	end
end	
###############################################################
get '/get_nfo' do
	#msg = params[:msg]
	erb :input
end
##############################################################
##################################################################
post '/get_nfo' do
  data = params[:data]
	#makedatable()
	add_entry(data)

redirect '/return'
end
# #######################################################
post '/search' do
	phown = params[:phown]
	#result = params[:result].to_s
	#p "#{result}is this itititititititititit"
	#p "#{phown}..where's my search numberrrrrrrrrrrrrebmun"
  redirect '/return?phown='+phown
end	
###############################
get '/return' do
 	phown = params[:phown]

	  if phown != nil
			result = searcher(phown)
	 #  	pbinfo = {
		#     host: ENV['RDS_HOST'],
		#     port:ENV['RDS_PORT'],
		#     dbname:ENV['RDS_DB_NAME'],
		#     user:ENV['RDS_USERNAME'],
		#     password:ENV['RDS_PASSWORD']
	 #  	db = PG::Connection.new(pbinfo)
		# list = db.exec("SELECT * FROM public.pb")
	 #  }
		#result = check.values
	  else
	  		result = ""
		end
				pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }	
	  	db = PG::Connection.new(pbinfo)
		list = db.exec("SELECT * FROM public.pb")
	 
	erb :return, locals:{list:list,result:result}  	
end
# #######################################
post '/return' do
	result = params[:result]
	awsd = params[:awsd]
#p "made it to return "
	redirect '/changeit?awsd='+awsd
end	
##########################################
get '/changeit' do
	awsd = params[:awsd]
	  pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }
	db = PG::Connection.new(pbinfo)
	updt = db.exec("SELECT * FROM public.pb WHERE id = '#{awsd}'")
	erb :change, locals:{updt:updt,awsd:awsd}
end
# # #######################################################
# get '/results' do
# 	phown = params[:phown]
# 	result = searcher(phown)

# 	erb :change, locals:{result:result}
# end	
# #######################################################
# #######################################################
post '/changeit' do
  awsd = params[:awsd]
  f_name = params[:f_name]
  l_name = params[:l_name]
  street = params[:street]
  city = params[:city]
  state = params[:state]
  zip = params[:zip]
  phone = params[:phone]
	radio = params[:radio]
 
 pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }
	db = PG::Connection.new(pbinfo)
	if radio == 'update'
    db.exec("UPDATE public.pb SET f_name='#{f_name}',l_name='#{l_name}',street='#{street}',city='#{city}',state='#{state}',zip='#{zip}',phone='#{phone}' WHERE id = '1'")
  		redirect '/get_nfo'
  elsif radio == 'delete'
  		redirect '/return'
    db.exec("DELETE FROM  public.pb WHERE id = '#{awsd}'")
    	redirect '/return'
  else radio == 'cancel'
    	redirect '/'
  end
end
