#!/usr/bin/env ruby 
require 'rubygems'
require 'hpricot'
require 'net/http'
require 'uri'
# require 'open3'


class RRSFetcher
  attr_accessor :download_list
  attr_accessor :app
  def initialize
    @download_list = []
    @app = :wget
  end

  dee self.get_page(url)
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
    unless ff
      #DEBUG
      File.open("error_page.html", "wb") do |file|
        file.write(page)
      end
    else
      action = ff.attr("action")
      name = "dl.start"
      value = "free"
      resp = Net::HTTP.post_form(URI.parse(action), {name=>value})
      result = RRSFetcher.parse_second_page(resp.body)
      result[:action] = action
      result
    end
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
      file = propieties[:dlf].split("/").last
      case @app
      	when :curl
	  cmd = "curl --url #{propieties[:dlf]} --data 'mirror=on&x=67&y=50' > #{file}"
	when :wget
          cmd = "wget #{propieties[:dlf]} --post-data='mirror=on&x=67&y=50'"
	when :kget4
	  url = %@#{propieties[:dlf]}?mirror=on&x=67&y=50@
	  cmd = "qdbus org.kde.kget /kget/MainWindow_1 org.kde.kget.addTransfer '#{url}' ./#{file} true"
      end

      system(cmd)

#       process = Open3.popen3(cmd)
    end
  end
end

if __FILE__ == $0
  downloader = RRSFetcher.new
  downloader.app = :curl
  if ARGV[0]
    downloader.add_download(ARGV[0])
    thread = Thread.new do
      downloader.start_dowload
    end
    thread.join
  end
end
