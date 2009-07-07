class RR2Fetcher
  VERSION = "0.2"

  attr_accessor :download_list
  attr_accessor :app

  def initialize(options)
    @download_list = []
    @app = options[:backend]
    @options = options
  end

  def add_download(*links)
    links.each do |link|
      if File.exist?(link)
        File.open(link) do |f|
          @download_list += f.readlines
        end
      else
        @download_list << link
      end
    end
  end

  def start_dowload
    while !@download_list.empty?
      url = @download_list.pop.strip
      next if url.empty? || downloaded?(url)
      download url
    end
  end

  def download(to_download)
    parser = RSSParser.new(to_download)

    wait_until_ready(parser)
    agent = "Mozilla Firefox 1.5"

    cmd = "wget -U '#{agent}' '#{parser.download_link}' --post-data='mirror=on&x=67&y=50'"
    file = parser.filename # FIXME: check if download_link is valid

    case @app
      when :curl
        cmd = "curl -A '#{agent}' --url '#{parser.download_link}' --data 'mirror=on&x=67&y=50' > #{file}"
      when :kget4
        url = %@'#{parser.download_link}?mirror=on&x=67&y=50'@
        cmd = "qdbus org.kde.kget /kget/MainWindow_1 org.kde.kget.addTransfer '#{parser.download_link}' ./#{file} true"
    end

    system(cmd)
  end

  private
  def downloaded?(url)
    filename = url.to_s.split("/").last

    if File.exist?(filename)
      $stderr.puts "Already downloaded: #{filename}"
      return true
    end
    false
  end

  def wait_until_ready(parser)
    while parser.metadata.include?(:minutes)
      show_delay(parser.metadata[:minutes] * 60)
      parser.parse_next_page
    end

    show_delay(parser.metadata[:seconds])
  end

  def show_delay(seconds)
    seconds += 5

    pbar = ProgressBar.new("Waiting", seconds)
    seconds.times do |i|
      pbar.inc
      sleep(1)
    end
    pbar.finish
  end
end
