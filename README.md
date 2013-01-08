DevPanel
====

DevPanel is time saving tool for Rails Development that displays itself in the browser as a panel to provide useful information about the page load times and other
debugging info. It allows you to quickly pin point slow pages or inefficencies within your web app without ever having to scroll through logs.

### Features
* Shows render times for the Controller, View and Model as well as the overall time spent on the current page load.
* Shows which controller was called and which controller action so you can easily find out where the code for the current page is.
* Shows how many views were rendered to help identify inefficiencies.
* Shows the response code returned as well as the HTTP request method.
* Shows params so you can see what was passed to your controller.
* Provides a logging facilty so you don't have to search your log files. Just say `DevPanel::Stats.log("some val")` and it will display
  in the panel. No need to raise an exception anymore. 
* Allows you to drag and drop the panel anywhere on the page and it will save that location between requests. It rests to the top left
  on server restart

![Alt text](https://raw.github.com/MattStopa/DevPanel/master/sample.jpg?login=MattStopa&token=c291d1679b2ec07ac4a4ff112079a3aa)


### Installation

Just add the following to your Gemfile and restart your app server. DevPanel will display in the upper left and corner. 
If you wish to move it's location just drag it anywhere you'd like, it will keep that locations between requests.
    
    group :development do
      gem "dev_panel"
    end
    
### Notes

Be aware that DevPanel loads JQuery and JQuery UI at the bottom of your page. I'm going to make this an optional feature soon
but for now it's hard coded in there. Expect a new version to fix this within a few days. 
