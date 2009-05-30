class RSSParser
  attr_reader :page, :metadata, :url, :form_action
  def initialize(url)
    @page = Hpricot(Net::HTTP.get(URI.parse(url)))
    @url = url

    find_form_action
  end

  def parse_next_page
    @metadata = {}

    resp = Net::HTTP.post_form(URI.parse(@form_action), {"dl.start"=>"free"})
    body = resp.body

    body.each_line do |line|
      if line =~ /.*name="dlf"\sform_action="(\S*)"/
        @metadata[:dlf] = $1
      end

      if line =~ /var\s*c\s*=\s*(\d+)/
        @metadata[:seconds] = $1.to_i
      elsif line =~ /try\s*again\s*in\s*about\s*(\d+)\s*minutes/
        @metadata[:minutes] = $1.to_i
      end
    end

    @metadata
  end

  protected
  def find_form_action
    ff = @page.search("#ff")
    unless ff
      $stderr.puts "there was an error"
      return false
    end

    @form_action = ff.attr("action")
    true
  end
end
