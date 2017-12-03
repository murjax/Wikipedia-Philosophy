require 'mechanize'

class Page
  attr_reader :current_page, :visited_pages

  def initialize(current_page_title, visited_pages)
    mechanize = Mechanize.new
    current_page_url = "http://www.wikipedia.org/wiki/#{current_page_title}"

    @current_page = mechanize.get(current_page_url)
    @visited_pages = visited_pages
    @index = 0
  end

  def search_body_for_link
    current_page.search('//div[@id="bodyContent"]/div[@id="mw-content-text"]/div[@class="mw-parser-output"]/p/a')
  end

  def search_link
    while true
      return next_page_link unless !next_page_link || link_invalid?
      @index += 1
    end
  end

  def link_invalid?
    invalid_wiki_link?(next_page_link, visited_pages) || next_page_link.include?("abbreviations")
  end

  def invalid_wiki_link?(link, visited_pages)
    external_link?(link) || was_visited?(link, visited_pages)
  end

  def next_page_link
    search_body_for_link[@index].attributes["href"].value if link_exists?(search_body_for_link)
  end

  def link_exists?(link_location)
    link_location && link_location[@index] && link_location[@index].attributes["href"]
  end

  def external_link?(link)
    link.include?("http")
  end

  def title
    current_page.title
  end

  def uri
    current_page.uri.to_s
  end

  def was_visited?(link, visited_pages)
    visited_pages.each { |page| return true if page.include?(link) }
    false
  end
end
