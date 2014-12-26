module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :dev_panel_output, :if => lambda { request.format.to_s == "text/html" && !(!!request.xhr?) }
    end

    def dev_panel_output
      self.response.body += dev_panel_ajax
    end

    def dev_panel_ajax
      puts "#{jquery_cdn.nil?} + #{jquery_ui_cdn.nil?} + #{ajax_call}"
      jquery_cdn + jquery_ui_cdn + ajax_call
    end

    def ajax_call
      <<-html_code
        <div id="DevPanel"></div><script type="text/javascript">
          var $jq = jQuery.noConflict();
          $jq.ajax({
            url: "/__DevPanel/main",
            success: function(response) {
              $jq("#DevPanel").html(response);
              #{hide_container};
              $jq("#consoleButton").click(function(e){
                $("#console").toggle();
                $jq("#console").css('top', e.pageY + 10 + 'px');
                $jq("#console").css('left', e.pageX + 10 + 'px');
              })

              previous = null;

              $jq("#consoleInput").keydown(function(e) {
                if(event.keyCode == 38) {
                  $jq("#consoleInput").val(previous);
                }

                if(event.which == 13) {

                  if($jq("#consoleInput").val() == "") {
                    $jq("#consoleResults").append("><br>");
                    return "";
                    $jq("#consoleResults")[0].scrollTop = $jq("#consoleResults")[0].scrollHeight
                  }
                    $jq.ajax({
                      url: "/__DevPanel/console?query=" + $jq("#consoleInput").val(),
                      success: function(results) {
                        previous = $jq("#consoleInput").val()
                        $jq("#consoleResults").append(">" + results + "<br>");
                        $jq("#consoleInput").val("");
                        $jq("#consoleResults")[0].scrollTop = $jq("#consoleResults")[0].scrollHeight
                      }

                    })
                  }
              })

              $jq("#viewTime").click(function(e) {
                $jq("#partialList").css('top', e.pageY + 10 + 'px');
                $jq("#partialList").css('left', e.pageX + 10 + 'px');
                $jq("#partialList").toggle();
              });
              $jq("#devPanelHider").on("click", function(s) {
                $jq("#devPanelContainer").slideToggle(110);
                $jq("#partialList").hide();
                $jq("#console").hide();
                $jq.get("/__DevPanel/set_options?visible=" + $jq("#devPanelContainer").is(":visible"));
              });
              $jq("#devPanelWindow").draggable({stop: function() {
                $jq.get("/__DevPanel/set_options?top=" + $jq("#devPanelWindow").position().top + "&left="
                                                     + $jq("#devPanelWindow").position().left + "&zindex="
                                                     + $jq("#devPanelWindow").zIndex() )
              }});
            }
          });
        </script>
      html_code
    end

    def hide_container
      (Stats.show?) ? '' : '$jq("#devPanelContainer").toggle()'
    end

    def config_key(value)
      begin
        return Rails.application.config.send(value)
      rescue
        return nil
      end
    end

    def jquery_cdn
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>'
    end

    def jquery_ui_cdn
      '<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>'
    end
  end
end