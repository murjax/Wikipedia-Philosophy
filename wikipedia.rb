require 'Nokogiri'
require 'HTTParty'
require 'mechanize'

def search_link(page, visited_pages)
  link = nil

  index = 0
  while !link && !visited_pages.include?(page.title)
    link = page.search('//div[@class="mw-parser-output"]/p/a')[index].attributes["href"].value
    index += 1
  end
  link
end

puts "Please enter the title of your page:"
page_title = gets
puts page_title
mechanize = Mechanize.new
page = mechanize.get("http://wikipedia.org/wiki/#{page_title}")
visited_pages = []

index = 0
while true && index < 5 do
  puts page.title
  first_link = search_link(page, visited_pages)
  next_page = "http://www.wikipedia.org/#{first_link}"
  visited_pages.push(page.title)
  page = mechanize.get(next_page)
    index += 1
end

