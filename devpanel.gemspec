Gem::Specification.new do |s|
  s.name        = 'dev_panel'
  s.version     = '0.2.4'
  s.date        = '2013-02-04'
  s.summary     = "DevPanel, a gem for performance stats and debugging information"
  s.description = "A panel that appears in the browser to provide stats on page load times and other debugging information for Rails 3"
  s.authors     = ["Matthew Stopa"]
  s.email       = 'matthew.p.stopa@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + ["lib/dev_panel.rb"]
  s.homepage    =
    'http://github.com/MattStopa/DevPanel'
end
