module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :dev_panel_output, :if => lambda { request.format.to_s == "text/html" && !(!!request.xhr?) }
    end

    def dev_panel_output
      self.response.body += dev_panel_ajax
    end

    def dev_panel_ajax
      jquery_cdn + jquery_ui_cdn + ajax_call
    end

    def ajax_call
      <<-html_code
        <div id="DevPanel"></div><script type="text/javascript">
          $.ajax({
            url: "/__DevPanel/main",
            success: function(response) {
              $("#DevPanel").html(response);
              #{hide_container};
              $("#viewTime").click(function(e) {
                $("#partialList").css('top', e.pageY + 10 + 'px');
                $("#partialList").css('left', e.pageX + 10 + 'px');
                $("#partialList").toggle();
              });
              $("#devPanelHider").on("click", function(s) {
                $("#devPanelContainer").toggle();
                $("#partialList").hide();
                $.get("/__DevPanel/set_options?visible=" + $("#devPanelContainer").is(":visible"));
              });
              $("#devPanelWindow").draggable({stop: function() {
                $.get("/__DevPanel/set_options?top=" + $("#devPanelWindow").position().top + "&left="
                                                     + $("#devPanelWindow").position().left + "&zindex="
                                                     + $("#devPanelWindow").zIndex() )
              }});
            }
          });
        </script>
      html_code
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