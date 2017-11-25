require 'Nokogiri'
require 'HTTParty'
require 'mechanize'

def search_link(page, visited_pages)
  index = 1
  while true
    link_location = page.search('//div[@class="mw-parser-output"]/p/a')
    link = link_location[index].attributes["href"].value if link_exists?(link_location, index)
    return link unless !link || invalid_wiki_link?(link, visited_pages)
    index += 1
  end
end

def invalid_wiki_link?(link, visited_pages)
  external_link?(link) || was_visited?(link, visited_pages)
end


def link_exists?(link_location, index)
  link_location && link_location[index] && link_location[index].attributes["href"]
end

def external_link?(link)
  link.include?("http")
end

def was_visited?(link, visited_pages)
  visited_pages.each { |page| return true if page.include?(link) }
  false
end

def start
  puts "Please enter the title of your page:"
  page_title = gets
  puts page_title
  mechanize = Mechanize.new
  page = mechanize.get("http://wikipedia.org/wiki/#{page_title}")
  visited_pages = []

  while page.title != "Philosophy - Wikipedia" do
    puts page.title
    first_link = search_link(page, visited_pages)
    next_page = "http://www.wikipedia.org/#{first_link}"
    visited_pages.push(page.uri.to_s)
    page = mechanize.get(next_page)
  end

  puts page.title
  puts "Done!"
end

start
