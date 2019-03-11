#!/usr/bin/ruby

require 'nokogiri'
require 'open3'

source=ARGV[1]
dest=ARGV[2]

WPT_PREAMBLE=<<-HEREDOC
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <script src="/resources/testharness.js"></script>
  <script src="/resources/testharnessreport.js"></script>
  <script>
HEREDOC

WPT_PREAMBLE_OFFSET=WPT_PREAMBLE.length

WPT_POSTAMBLE=<<-HEREDOC
  </script>
</head>
</body>
</html>
HEREDOC

WPT_POSTAMBLE_OFFSET=WPT_POSTAMBLE.length

source = File.read(ARGV[0])

script = Nokogiri::HTML(source).css("//script").map { |e| e.content }.join("\n")

# name ?
script = script.gsub("SimpleTest.waitForExplicitFinish()", "var t = async_test()");
# is load event really required ?
script = script.gsub(/addLoadEvent\(function\(\) *{\n(.*)}\);/m, '\1')
script = script.gsub("SimpleTest.finish();", "t.done();")
script = script.gsub("ok(", "assert_true(")
script = script.gsub("is(", "assert_equals(")
script = script.gsub(/ *expectException\(function\(\) *{\n *(.*?)}, DOMException.([A-Z_]*?)\);/m, 'assert_throws("\2", function() {\1});')

cmd = "prettier --stdin --parser babel"

STDOUT.sync = true

Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  stdin.puts(script)
  stdin.close()
  script = stdout.read
end

script = WPT_PREAMBLE + script + WPT_POSTAMBLE

print script

