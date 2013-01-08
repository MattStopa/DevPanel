DevPanel
====

DevPanel is a panel that displays itself in the browser to provide useful information about the page load times and other
debugging information for Rails 3 Applications. It allows you to quickly pin point slow pages or inefficencies within
your web app without ever having to scroll through logs.

### Features
* Shows render times for the Controller, View and Model as well as the overall time spent on the current page load.
* Shows which controller was called and which controller action so you can easily find out where the code for the current page is.
* Shows how many views were rendered to help identify inefficines.
* Shows the response code returned as well as the HTTP request method.
* Shows params so you can see what was passed to your controller.
* Provides a logging facilty so you don't have to search your log files. Just say 
