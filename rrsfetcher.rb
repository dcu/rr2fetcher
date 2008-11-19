require 'rubygems'
require 'hpricot'
require 'net/http'
require 'uri'
# require 'open3'


class RRSFetcher
  attr_accessor :download_list
  def initialize
    @download_list = []
  end

  def self.get_page(url)
    Hpricot(Net::HTTP.get(URI.parse(url)))
  end

  def self.parse_second_page(body)
    rest = {}
    body.each_line do |line|
      if line =~ /.*name="dlf"\saction="(\S*)"/
        rest[:dlf] = $1
      end

      if line =~ /var\s*c\s*=\s*(\d+)/
        rest[:seconds] = $1.to_i
      elsif line =~ /try\s*again\s*in\s*about\s*(\d+)\s*minutes/
        rest[:minutes] = $1.to_i
      end
    end
    rest
  end

  def self.link_propieties(link)
    page = RRSFetcher.get_page(link)
    ff = page.search("#ff")
    action = ff.attr("action")
    name = "dl.start"
    value = "free"
    resp = Net::HTTP.post_form(URI.parse(action), {name=>value})
    result = RRSFetcher.parse_second_page(resp.body)
    result[:action] = action
    result
  end

  def add_download( link)
    p "adding #{link} to download queue"
    @download_list << link
  end

  def start_dowload
    def show_delay(seconds)
      seconds.times do |i|
        print "#{i} ";
        sleep(1)
      end
    end
    while(!download_list.empty?)
      to_download = @download_list.pop
      propieties = RRSFetcher.link_propieties(to_download)
      while(propieties.include?(:minutes))
        p "minutes #{result[:minutes]}"
        show_delay(result[:minutes] * 60)
        propieties = Net::HTTP.post_form(URI.parse(action), {name=>value})
        RRSFetcher.parse_second_page(resp)
      end
      show_delay(propieties[:seconds])
      p "go!!"
      cmd = "wget #{propieties[:dlf]} --post-data='mirror=on&x=67&y=50'"
      system(cmd)

#       process = Open3.popen3(cmd)
    end
  end
end

if __FILE__ == $0
  downloader = RRSFetcher.new
  if ARGV[0]
    downloader.add_download(ARGV[0])
    thread = Thread.new do
      downloader.start_dowload
    end
    thread.join
  end
end
