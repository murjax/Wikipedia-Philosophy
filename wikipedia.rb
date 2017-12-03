require 'Nokogiri'
require 'HTTParty'
require_relative 'input'
require_relative 'page'

class Wikipedia
  def initialize
    @visited_pages = []
    @page_title = Input.get_page_title
    @current_page = Page.new(@page_title, @visited_pages);
    start
  end

  def start
    while @current_page.title != "Philosophy - Wikipedia" do
      puts @current_page.title
      next_page_title = @current_page.search_link
      @visited_pages.push(@current_page.uri)
      @current_page = Page.new(next_page_title, @visited_pages)
    end

    puts @current_page.title
    puts "Done!"
  end
end

wikipedia_search = Wikipedia.new
