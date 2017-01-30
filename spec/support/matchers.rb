require 'rspec/expectations'

RSpec::Matchers.define :be_a_pdf do |expected|
  match do |actual|
    text = File.open(actual.url)
    text.start_with?('%PDF-1.4')
    text.end_with?('%%EOF')
    text.length > 100
  end
end
