require 'Nokogiri'
require 'HTTParty'
require 'mechanize'

def search_link(page, visited_pages)
  index = 1
  link = nil

  while !link && !visited_pages.include?(page.title)
    link_location = page.search('//div[@class="mw-parser-output"]/p/a')
    link = link_location[index].attributes["href"].value if link_exists?(link_location, index)
    link = nil if link && external_link?(link)
    index += 1
  end
  link
end

def link_exists?(link_location, index)
  link_location && link_location[index] && link_location[index].attributes["href"]
end

def external_link?(link)
  link.include?("http")
end

puts "Please enter the title of your page:"
page_title = gets
puts page_title
mechanize = Mechanize.new
page = mechanize.get("http://wikipedia.org/wiki/#{page_title}")
visited_pages = []

while page.title != "Philosophy - Wikipedia" do
  puts page.title
  first_link = search_link(page, visited_pages)
  require 'pry'; binding.pry;

  next_page = "http://www.wikipedia.org/#{first_link}"
  visited_pages.push(page.title)
  page = mechanize.get(next_page)
end

puts page.title
puts "Done!"

