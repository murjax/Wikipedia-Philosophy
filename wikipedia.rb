require 'Nokogiri'
require 'HTTParty'
require_relative 'input'
require_relative 'page'

class Wikipedia
  def initialize
    @visited_pages = []
    @current_page = Page.new(Input.get_page_title, @visited_pages);
    start
  end

  def start
    while @current_page.title != "Philosophy - Wikipedia" do
      mark_page_visited
      @current_page = Page.new(@current_page.search_link, @visited_pages)
    end
    show_completion_message
  end

  def mark_page_visited
    show_page_title
    add_to_visited
  end

  def add_to_visited
    @visited_pages.push(@current_page.uri)
  end

  def show_page_title
    puts @current_page.title
  end

  def show_completion_message
    show_page_title
    puts 'Done!'
  end
end

wikipedia_search = Wikipedia.new
