require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

page = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')

parse_page = Nokogiri::HTML(page)

pets_array = []

parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
  post_name = a.text
  pets_array.push(post_name)
end

Pry.start(binding)

#wrote the above to scrap a site. Need to learn how to login to a site:
#http://crabonature.pl/posts/23-automation-with-mechanize-and-ruby
