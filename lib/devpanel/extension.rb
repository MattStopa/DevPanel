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
              $jq("#viewTime").click(function(e) {
                $jq("#partialList").css('top', e.pageY + 10 + 'px');
                $jq("#partialList").css('left', e.pageX + 10 + 'px');
                $jq("#partialList").toggle();
              });
              $jq("#devPanelHider").on("click", function(s) {
                $jq("#devPanelContainer").slideToggle(110);
                $jq("#partialList").hide();
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