## Versions

### 0.3

- Add a basic rails console in dev_panel.

### 0.2.7

- Add percentage time taken for each action (controller/view)

### 0.2.6

- Completely redesign the panel. This is experimental and may change. Mostly
  done because I'm looking to make the look a bit more compact, but it's not
  perfect yet. 
- Change "Show/Hide Stats" to the controller and action. This lets you instantly
  know upon page load exactly what controller and action is being called
  to load the page.
- Color coding based on performance of the page. Green is fast, Yellow is slower
  orange is slower still and red is "We got a problem". Right now this isn't 
  configurable but will be in the future.

### 0.2.5

- Fixed Z-Index issues with Dev Panel not showing up at times. 
- Fix JQuery issue so without any config there should be no conflicts now.

