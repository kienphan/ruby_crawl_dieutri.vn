require 'nokogiri'
require 'open-uri'

CRAWLED_HOST = "http://www.dieutri.vn/"

# Fetch and parse HTML document
def results_list
  sickness_type = [
    "hohap", "timmach", "tamthan", "tieuhoa", "xuongkhop", "nieuhoc", "noitiet",
    "benhmau", "thankinh", "truyennhiem", "sanphu", "tuyenvu", "dalieu", "benhmat",
    "taimuihong", "rangmieng", "vatly", "ngodoc", "treem", "diung", "chuyenhoa",
    "sinhsan", "benhkhac"
  ]
  results = Array.new
  sickness_type.each do |e|
    doc = Nokogiri::HTML(open("#{CRAWLED_HOST}#{e}.htm"))
    doc.search("div .item-news").each do |item|
      link_selector = item.search("a")[0].attributes
      title = link_selector["title"].value
      short_description = item.search("p")[0].content
      url = link_selector["href"].value
      results.push({title: title, short_description: short_description, img_url: "", url: "#{CRAWLED_HOST}#{url}"})
    end
  end
  results
end

results = results_list
# p results
File.open("~/kp_dev/data.yml", "w+") do |file|
  results.each do |e|
    file.write "- title: \"#{e[:title]}\"\n"
    file.write "  short_description: \"#{e[:short_description]}\"\n"
    file.write "  img_url: \"#{e[:img_url]}\"\n"
    file.write "  url: \"#{e[:url]}\"\n"
  end
end

puts "Done!!!"
