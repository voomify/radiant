Then /^I should see "([^\"]*)"$/ do |text|
  # response.should contain(text)
  response.body.should match(Regexp.new(text))
end

Then /^I should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  response.should contain(regexp)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  # response.should_not contain(text)
  response.body.should_not match(Regexp.new(text))
end

Then /^I should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  response.should_not contain(regexp)
end