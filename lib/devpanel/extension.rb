module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :debug_output
    end

    def debug_output
      self.response.body += debug_html_response
    end

    def debug_html_response
      r = (Stats.hidden) ? '$("#basementContainer").toggle()' : '';

      '<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script><div id="DevPanel"></div>
        <script type="text/javascript">$.ajax({
          url: "/__DevPanel/main",
          success: function(response) {
            $("#DevPanel").html(response);' + r +
            '
            $("#basementHider").on("click", function(s) {
              $("#basementContainer").toggle();
              $.get("/__DevPanel/set_options?hidden=" + $("#basementContainer").is(":visible"));
            });
            $("#basementWindow").draggable({stop: function() {
              $.get("/__DevPanel/set_options?x=" + $("#basementWindow").position().top + "&left=" + $("#basementWindow").position().left);
            }});
          }
        });
      </script>'
    end
  end
end