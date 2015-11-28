module DevPanel
  module Panel

    def self.included(base)
      base.after_filter :dev_panel_output, :if => lambda { request.format.to_s == "text/html" && !(!!request.xhr?) }
    end

    def dev_panel_output
      self.response.body += panel
    end

    def panel
      <<-html_code
        <script>
        window.onload = function() {
          body = document.getElementsByTagName('body')[0]
          iframe = document.createElement('iframe')
          iframe.setAttribute('src', '__DevPanel/main')
          iframe.setAttribute('id', 'devPanel')
          iframe.setAttribute('style', 'width: 100%; border: none;')
          body.insertBefore(iframe ,body.children[0])
        }

        window.resizeDevPanel = function(height) {
          element = document.getElementById('devPanel')
          console.log(height)
          element.setAttribute('height', height)
        }

        </script>
      html_code
    end

    def hide_container
      (Stats.show?) ? '' : '$jq("#devPanelContainer").toggle()'
    end
  end
end