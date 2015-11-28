Gem::Specification.new do |s|
  s.add_development_dependency "rspec"
  s.name        = 'dev_panel'
  s.version     = '1.1'
  s.date        = '2015-11-27'
  s.summary     = "DevPanel, a gem for performance stats and debugging information"
  s.description = "A panel that appears in the browser to provide stats on page load times and other debugging information for Rails 3 & 4"
  s.authors     = ["Matthew Stopa"]
  s.email       = 'matthew.p.stopa@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + ["lib/dev_panel.rb"] + Dir['lib/**/assets/*.*'] + Dir['lib/**/views/*.*']
  s.homepage    =
    'http://github.com/MattStopa/DevPanel'
end
