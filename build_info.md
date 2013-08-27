Process
==

More or less this is for me because I tend to forget the process each time I come back to the gem :-)

## Steps to get DevPanel running locally

- Clone the repo
- Get one of you projects to point to the repo in the gemfile (  gem 'dev_panel', :path => "/Users/MattStopa/Development/DevPanel")
- Run your all... Viola, it all works

## Steps to build the gem.

- gem build devpanel.gemspec

## Require the new gem version in your app

- gem 'dev_panel', '~> 4.0.0'
- gem install /full/path/to/your.gem

Make sure it works and you are done.