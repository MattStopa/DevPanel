module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :debug_output
    end

    def debug_output
      self.response.body += debug_html_response
    end

    def debug_html_response
      hide_container = (Stats.hidden) ? '$("#devPanelContainer").toggle()' : '';

      '<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script><div id="DevPanel"></div>
        <script type="text/javascript">$.ajax({
          url: "/__DevPanel/main",
          success: function(response) {
            $("#DevPanel").html(response);' + hide_container +
            '
            $("#devPanelHider").on("click", function(s) {
              $("#devPanelContainer").toggle();
              $.get("/__DevPanel/set_options?hidden=" + $("#devPanelContainer").is(":visible"));
            });
            $("#devPanelWindow").draggable({stop: function() {
              $.get("/__DevPanel/set_options?x=" + $("#devPanelWindow").position().top + "&left=" + $("#devPanelWindow").position().left);
            }});
          }
        });
      </script>'
    end
  end
end