module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :dev_panel_output
    end

    def dev_panel_output
      self.response.body += dev_panel_ajax
    end

    def dev_panel_ajax
      jquery_cdn + jquery_ui_cdn + ajax_call
    end

    def ajax_call
      '<div id="DevPanel"></div><script type="text/javascript">
        $.ajax({
          url: "/__DevPanel/main",
          success: function(response) {
            $("#DevPanel").html(response);' + hide_container +
            '
            $("#devPanelHider").on("click", function(s) {
              $("#devPanelContainer").toggle();
              $.get("/__DevPanel/set_options?visible=" + $("#devPanelContainer").is(":visible"));
            });
            $("#devPanelWindow").draggable({stop: function() {
              $.get("/__DevPanel/set_options?top=" + $("#devPanelWindow").position().top + "&left=" + $("#devPanelWindow").position().left);
            }});
          }
        });
      </script>'
    end

    def hide_container
      (Stats.show?) ? '' : '$("#devPanelContainer").toggle()'
    end

    def jquery_cdn
      begin
        return '' if Rails.application.config.dev_panel_exclude_jquery == true
      rescue
        '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>'
      end
    end

    def jquery_ui_cdn
      begin
        return '' if Rails.application.config.dev_panel_exclude_jquery_ui == true
      rescue
        '<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>'
      end
    end
  end
end