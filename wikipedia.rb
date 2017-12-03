require 'Nokogiri'
require 'HTTParty'
require 'mechanize'
require_relative 'page.rb'

def start
  puts "Please enter the title of your page:"
  page_title = gets
  puts page_title
  mechanize = Mechanize.new
  page = mechanize.get("http://wikipedia.org/wiki/#{page_title}")
  visited_pages = []

  while page.title != "Philosophy - Wikipedia" do
    puts page.title
    current_page = Page.new(page, visited_pages)
    first_link = current_page.search_link
    next_page = "http://www.wikipedia.org/#{first_link}"
    visited_pages.push(page.uri.to_s)
    page = mechanize.get(next_page)
  end

  puts page.title
  puts "Done!"
end

start
