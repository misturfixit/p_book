require 'sinatra'
require 'pg'
require_relative 'funk.rb'
enable 'sessions'
	load './local_env.rb' if File.exist?('./local_env.rb')
########################################
get '/' do
	erb :input
end
################################
post '/get_nfo' do
  data = params[:data]
	 #makedabase
	 add_entry(data)

redirect '/return'
end
###############################
 get '/return' do
#{}"HELOO WORLD"
#	begin
	  pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }
	  db = PG::Connection.new(pbinfo)
	  list = db.exec('SELECT * FROM public.pb') 
	#p "#{list[0]}"

  # rescue PG::Error => e
  #   puts e.message
  # ensure
 #   pb.close if pb
 # 	dat = params[:dat]
	#list = params[:list]
	erb :return, locals:{list:list}
 end
# #######################################
post '/return' do
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
# #######################################################
# post '/update' do
# 	awsd = params[:awsd]
# 	redirect '/changeit?awsd='+awsd
# end	
# # #######################################################

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
	pb = PG::Connection.new(pbinfo)
	if radio == 'update'
    pb.exec("UPDATE public.pb SET f_name='#{f_name}',l_name='#{l_name}',street='#{street}',city='#{city}',state='#{state}',zip='#{zip}',phone='#{phone}' WHERE id = '1'")
  elsif radio == 'delete'
  		redirect '/'
    pb.exec("DELETE FROM  public.pb WHERE id = '#{awsd}'")
    	redirect '/'
  else radio == 'cancel'
    	redirect '/'
  end
end
