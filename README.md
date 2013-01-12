Dev Panel
====

dev_panel is time saving tool for Rails Development that displays itself in the browser as a panel to provide useful information about the page load times and other
debugging info. It allows you to quickly pin point slow pages or inefficencies within your web app without ever having to scroll through logs.

### Features
* Shows render times for the Controller, View and Model (Model is coming soon) as well as the overall time spent on the current page load.
* Shows which controller was called and which controller action so you can easily find out where the code for the current page is.
* Shows how many views were rendered to help identify inefficiencies.
* Shows the response code returned as well as the HTTP request method.
* Shows params so you can see what was passed to your controller.
* Provides a logging facilty so you don't have to search your log files. Just say `DevPanel::Stats.log("some val")` and it will display
  in the panel. No need to raise an exception anymore.
* Allows you to drag and drop the panel anywhere on the page and it will save that location between requests. It resets to the top left
  on server restart

![Alt text](https://raw.github.com/MattStopa/DevPanel/master/sample.jpg?login=MattStopa&token=c291d1679b2ec07ac4a4ff112079a3aa)


### Installation

Just add the following to your Gemfile and restart your app server. DevPanel will display in the upper left and corner.
If you wish to move it's location just drag it anywhere you'd like, it will keep that locations between requests.

    group :development do
      gem "dev_panel"
    end

### Logging

One of dev_panel's most powerful features is to provide easy logging facilities that don't require using the Rails console, just edit your code and have debug info
appear in the browser. There are two primary features when it comes to logging with dev_panel.

##### Time Based Logging

Want to profile some code and see how long it takes to execute? Just wrap it in a `DevPanel::Stats.time` block and you'll see the results in the log portion of the panel.

    DevPanel::Stats.time do
      sleep(1)
    end

Now if you look in the dev_panel you'll see something like `1002.34` in the log section. easy code profiling, yay!

##### Log Anything

Want to output some object you are working with to the screen for a quick inspection? Use this so you don't have to put `raise`'s in your code.

    DevPanel::Stats.log(33.class)

Now if you look in the dev_panel you'll see `Fixnum`. Way easier logging, and you can add as many log statements as you want!


### Configuration

Be aware that DevPanel loads JQuery and JQuery UI at the bottom of your page via a CDN. Most people will have JQuery already and some will have JQuery UI as well, so if you have either one in your project you don't want those files included via CDN. In that case just put the following lines in your development.rb:

    config.dev_panel_exclude_jquery = true
    config.dev_panel_exclude_jquery_ui = true
