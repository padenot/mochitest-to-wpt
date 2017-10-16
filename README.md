# mochitest-to-wpt

Scripts to ease porting Gecko mochitest to web-platform-tests

Deps:
- ruby
  - nokogiri (gem install nokogiri)
- node
  - prettier (npm install prettier)


# Harnesses

web-platform-test: http://web-platform-tests.org/writing-tests/testharness-api.html
Mochitest: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Mochitest#Writing_tests

# Instructions

This is be automated a bit more, but for now:

```sh
hg cp path/to/old/test.html path/to/new/test.html
./mochitest-to-wpt.rb > path/to/new/test.html
./mach wpt --update-manifest path/to/new/test.html
# this runs the test, adjust the code as need, the conversion is not perfect
# ...
# it passes
hg commit -m"Bug xxx - convert mochitest xxx to a web-platform-test r?"
```
