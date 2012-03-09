require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

get '/ribbit' do
  content_type :js
  url = params[:url]
  id = "#" + params[:id]
  callback = params[:callback]
  doc = Nokogiri::HTML(open(url))
  frag = doc.css(id).to_s
  frag_json = frag.to_json
  "#{callback}(#{frag_json})"
end
