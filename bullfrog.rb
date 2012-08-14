require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

get '/ribbit' do
  content_type :js
  headers 'Access-Control-Allow-Origin' => '*'  
  url = params[:url]
  id = "#" + params[:id]
  callback = params[:callback]
  doc = Nokogiri::HTML(open(url))
  frag = doc.css(id).to_s
  frag_json = frag.to_json
  "#{callback}(#{frag_json})"
end

get '/parrot' do
  content_type :text
  headers 'Access-Control-Allow-Origin' => '*'  
  url = params[:url]
  callback = params[:callback]
  frag = open(url) { |f| f.read }
  frag_json = frag.to_json
  "#{callback}(#{frag_json})"
end

get '/byschema' do
  content_type :js
  headers 'Access-Control-Allow-Origin' => '*'  
  url = params[:url]
  callback = params[:callback]
  frags = []
  
  doc = Nokogiri::HTML(open(url))
  doc.css(".template").each do |node|
    frags << {:content => node.to_s}
  end
  "#{callback}(#{frags.to_json})"
end

post '/copy' do
  content_type :js
  headers 'Access-Control-Allow-Origin' => '*'  
  content = params[:data]
  File.open('copied.txt', 'w') { |f| f.write(content) }
  "''"
end

get '/paste' do
  content_type :js
  headers 'Access-Control-Allow-Origin' => '*'  
  callback = params[:callback] || "callback"
  content = ""
  begin
    File.open('copied.txt', 'r') { |f| content = f.read }
    File.delete('copied.txt')
  rescue
    content = ''
  end
  "#{callback}(#{content.to_json})"
end
# try copy paste using the inter-tab version of web sockets

# use example of linking/embedding to academic papers and show it as a reference (so resuse their data, apply my style)
