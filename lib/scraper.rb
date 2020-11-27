require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    master_array = []
    array_of_names = []
    array_of_locations = []
    array_of_urls_1 = []
    array_of_urls = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    names = doc.css(".student-name")
    locations = doc.css(".student-location")
    urls = doc.css(".student-card, a")
    names.each do |name|
      array_of_names << name.text.strip
    end 
    locations.each do |location|
      array_of_locations << location.text.strip
    end 
    urls.each do |url|
      array_of_urls_1 << url.get_attribute("href")
    end
    array_of_urls_1.each do |item|
      if item != nil && item != "#"
        array_of_urls << item
      end
    end
    i = 0
    array_of_names.length.times do
      master_array[i] = {}
      master_array[i][:name] = array_of_names[i]
      master_array[i][:location] = array_of_locations[i]
      master_array[i][:profile_url] = array_of_urls[i]
      i += 1
    end
    master_array
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    twit = doc.css("a[href^='https://twit']")
    link = doc.css("a[href^='https://www.linked']")
    git = doc.css("a[href^='https://git']")
    blog = doc.css("a[href$='.com/']")
    quote = doc.css(".profile-quote")
    bio = doc.css(".description-holder, p")
    if twit[0] != nil
      hash[:twitter] = twit[0].get_attribute("href")
    end
    if link[0]!= nil
      hash[:linkedin] = link[0].get_attribute("href")
    end
    if git[0]!= nil
      hash[:github] = git[0].get_attribute("href")
    end
    if blog[0]!= nil
      hash[:blog] = blog[0].get_attribute("href")
    end
    if quote[0]!= nil
      hash[:profile_quote] = quote[0].text.strip
    end
    if bio[0] != nil
      hash[:bio] = bio[0].text.strip
    end
      hash
  
  end

end

