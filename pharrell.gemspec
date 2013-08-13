lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "pharrell"
  s.version = "0.4.1"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Callum Stott"]
  s.email = ["callum@seadowg.com"]
  s.summary = "I'm a provider gurl."
  s.license = 'MIT'

  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
end
