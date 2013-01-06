module DevPanel
  class Middleware
    def initialize(app)
      @app = app
    end

    # Calls the Dev Panel middleware
    #
    # @param [Hash] env
    # @return [Array]
    def call(env)
      if env["REQUEST_URI"] =~ /__DevPanel\/main/
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, [dev_panel_output]]
      elsif env["REQUEST_URI"] =~ /__DevPanel\/set_options/
         p = Rack::Utils.parse_query(env['QUERY_STRING'], "&")
         Stats.hidden(p["hidden"]) if p["hidden"].present?
         Stats.x(p["left"]) if p["left"].present?
         Stats.y(p["x"]) if p["x"].present?
         Stats.log(" ")
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, ["#{Stats.hidden} #{Stats.x} #{Stats.y}"]]
      else
        @app.call(env)
      end
    end

   def dev_panel_output
     css + html_containers + html_table
   end

    def css
      "<style>
        #devPanelWindow {
          border-radius: 3px;
          margin-bottom: 2px;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.03), 1px 1px 0 rgba(0, 0, 0, 0.05), -1px 1px 0 rgba(0, 0, 0, 0.05), 0 0 0 4px rgba(0, 0, 0, 0.04);
          font-family: menlo, lucida console, monospace;
          border: 2px solid #000;
        }

        #devPanelHider {
          background: #F1F1F1;
          box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.3);
          overflow: hidden;
          padding: 6px 10px;
          border: solid 1px #CCC;
          border-bottom: 0;
          border-top-left-radius: 2px;
          border-top-right-radius: 2px;
        }

        #devPanelContainer {
          background-color: #fff;
          box-shadow: inset 3px 3px 3px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(0, 0, 0, 0.1);
        }

        #devPanelContainer td {
          color: #000;
          font-size: 9px;
          font-weight: normal;
          padding: 8px;
        }

        #devPanelContainer tr {
          background-color: #FACC9B;;
        }

        #devPanelContainer .alt {
          background-color: #FFF;;
        }
      </style>"
    end

    def html_containers
      str = '<div id="devPanelWindow" style="padding: 3px; color: #000; background-color: #F0F0F5; position: absolute; float: left; top: ' + Stats.y.to_s + 'px; left: ' + Stats.x.to_s + 'px;" >'
      str += '<div id="devPanelHider" style="width: 150px; text-align:center; border: solid 1px #fff"><a href="#">Show/Hide Stats</a> / ' +  Stats.data[:action_controller].duration.round(0).to_s + 'ms</div>'
      str += '<div id="devPanelContainer" style="width: 300px; padding: 20px">'
    end

    def html_table
      str = '<table style="width: 100%">'
      str += "<tr class='alt'><td><b>Total Time:</b></td> <td>#{Stats.data[:action_controller].duration.round(2).to_s}ms</td></tr>"
      controller_time = (Stats.data[:action_controller].duration - Stats.data[:action_controller].payload[:view_runtime])
      str += "<tr><td><b>Controller Time:</b></td> <td> <small>#{controller_time.round(2).to_s}ms</td></tr></small>"
      str += "<tr class='alt'><td><b>View Time:</b></td> <td>#{Stats.data[:action_controller].payload[:view_runtime].round(2).to_s}ms</td></tr>"
      str += "<tr><td><b>Partials Rendered:</b></td> <td> <small>#{Stats.data[:partial_count] || 0}</td></tr></small>"
      str += "<tr class='alt'><td><b>Response Code:</b></td> <td> <small>#{Stats.data[:action_controller].payload[:status].to_s}</td></tr></small>"
      str += "<tr><td><b>Controller:</b></td> <td> <small>#{Stats.data[:action_controller].payload[:controller].to_s}</td></tr></small>"
      str += "<tr class='alt'><td><b>Action:</b></td> <td> <small>#{Stats.data[:action_controller].payload[:action].to_s}</td></tr></small>"
      str += "<tr><td><b>Action:</b></td> <td> <small>#{Stats.data[:action_controller].payload[:method].to_s}</td></tr></small>"
      str += "<tr class='alt'><td><b>Params:</b></td> <td> <small>#{Stats.data[:action_controller].payload[:params]}</td></tr></small>"
      str += "<tr><td><b>Log:</b></td> <td> <small>#{Stats.data[:log]}</td></tr></small>"
      str += "</table></div></div>"
    end
  end
end