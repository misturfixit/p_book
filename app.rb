require 'sinatra'
require 'pg'
require_relative 'funk.rb'
enable 'sessions'
	load './local_env.rb' if File.exist?('./local_env.rb')
#+++++++++++++++++++++++++++ ++++++++++++++++++++++++++++++++++++++++++++++#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
get '/' do
	erb :input
end
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
post '/get_nfo' do
  data = params[:data]


redirect '/return'
end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
get '/return' do
	begin
	  pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }
	  #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#
	  pb = PG::Connection.new(pbinfo)
	  list = pb.exec('SELECT * FROM public.pb') 
	#p "#{list[0]}"

	# vals = rs.values
	# 	list = []
	# 	  vals.each do |row|
	# 	    list << row.values
	# 	     	list.each do |dat|
  #     				dat 
	# 	     	end	
	# 	  end
	#{}"%s %s %s %s %s %s %s" %
  rescue PG::Error => e
    puts e.message
  ensure
    pb.close if pb
 # 	dat = params[:dat]
	# list = params[:list]
erb :return, locals:{list:list}
	
end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
post '/return' do
	awsd = params[:awsd]
	redirect '/update?awsd='+awsd
end
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
get '/update' do
	awsd = params[:awsd]
	 pbinfo = {
		    host: ENV['RDS_HOST'],
		    port:ENV['RDS_PORT'],
		    dbname:ENV['RDS_DB_NAME'],
		    user:ENV['RDS_USERNAME'],
		    password:ENV['RDS_PASSWORD']
	  }
	pb = PG::Connection.new(pbinfo)
	updt = wb.exec("SELECT * FROM public.pb WHERE id = '#{awsd}'")
	erb :update, locals:{updt:updt,awsd:awsd}
	end
end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#