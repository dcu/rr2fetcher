class RRSFetcher
  attr_accessor :download_list
  attr_accessor :app

  def initialize
    @download_list = []
    @app = :wget
  end

  def add_download(link)
    @download_list << link
  end

  def start_dowload
    while !download_list.empty?
      download @download_list.pop
    end
  end

  def download(to_download)
    parser = RSSParser.new(to_download)

    wait_until_ready(parser)
    agent = "Mozilla Firefox 1.5"

    cmd = "wget -U '#{agent}' '#{parser.metadata[:dlf]}' --post-data='mirror=on&x=67&y=50'"
    file = parser.metadata[:dlf].split("/").last

    case @app
      when :curl
        cmd = "curl -A '#{agent}' --url #{properties[:dlf]} --data 'mirror=on&x=67&y=50' > #{file}"
      when :kget4
        url = %@#{properties[:dlf]}?mirror=on&x=67&y=50@
        cmd = "qdbus org.kde.kget /kget/MainWindow_1 org.kde.kget.addTransfer '#{url}' ./#{file} true"
    end

    system(cmd)
  end

  private
  def wait_until_ready(parser)
    while parser.metadata.include?(:minutes)
      $stderr.puts "minutes #{result[:minutes]}"
      show_delay(result[:minutes] * 60)
      parser.parse_next_page
    end

    show_delay(parser.metadata[:seconds])
  end

  def show_delay(seconds)
    seconds.times do |i|
      print "#{i} ";
      sleep(1)
    end
  end
end
