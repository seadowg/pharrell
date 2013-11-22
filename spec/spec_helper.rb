require 'simplecov'
SimpleCov.start do
  add_filter do |source_file|
    source_file.filename =~ /spec/
  end
end

require 'coveralls'
Coveralls.wear!