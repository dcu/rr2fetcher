require 'rrsfetcher'
require 'benchmark'

# ff = page.search("#ff")
# action = ff.attr("action")
# name = "dl.start"
# value = "free"

File.open("fixtures/page2.html", "r") do |file|
  bnk = Benchmark.realtime do
    RRSFetcher.parse_second_page(file.read)
  end
  p bnk
end