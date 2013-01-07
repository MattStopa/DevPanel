module DevPanel
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["REQUEST_URI"] =~ /__DevPanel\/main/
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, [dev_panel_output]]
      elsif env["REQUEST_URI"] =~ /__DevPanel\/set_options/
         params = Rack::Utils.parse_query(env['QUERY_STRING'], "&")
         Stats.set_by_params(params)
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, ["#{Stats.hidden} #{Stats.left} #{Stats.top}"]]
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
          font-family: arial;
          font-size: 12.8px;
          overflow: hidden;
          padding: 6px 10px;
          border: solid 1px #CCC;
          border-bottom: 0;
          border-top-left-radius: 2px;
          border-top-right-radius: 2px;
        }

        #devPanelContainer {
          font-family: menlo, lucida console, monospace;
          background-color: #fff;
          box-shadow: inset 3px 3px 3px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(0, 0, 0, 0.1);
        }

        #devPanelContainer td {
          font-family: arial;
          color: #000;
          font-size: 10px;
          font-weight: normal;
          padding: 8px;
          overflow: auto;
        }

        #devPanelContainer tr {
          background-color: #FACC9B;;
        }

        #devPanelContainer td.firstColumn {
          width: 60px;
          font-weight: bold;
        }

        #devPanelContainer .alt {
          background-color: #FFF;;
        }
      </style>"
    end

    def html_containers
      str = '<div id="devPanelWindow" style="padding: 3px; color: #000; background-color: #F0F0F5; position: absolute; float: left; top: ' + Stats.top.to_s + 'px; left: ' + Stats.left.to_s + 'px;" >'
      str += '<div id="devPanelHider" style="width: 150px; text-align:center; border: solid 1px #fff"><a href="#">Show/Hide Stats</a> / <span style="font-size: 10px">' +  Stats.data[:action_controller].duration.round(0).to_s + 'ms</span></div>'
      str += '<div id="devPanelContainer" style="width: 300px; padding-top: 20px">'
    end

    def html_table
      str = '<table style="width: 300px; table-layout: fixed">'
      str += "<tr class='alt'><td class='firstColumn'>Total Time:</td> <td>#{Stats.data[:action_controller].duration.round(2).to_s}ms</td></tr>"
      controller_time = (Stats.data[:action_controller].duration - Stats.data[:action_controller].payload[:view_runtime])
      str += "<tr><td class='firstColumn'>Controller Time:</td> <td> #{controller_time.round(2).to_s}ms</td></tr>"
      str += "<tr class='alt'><td class='firstColumn'>View Time:</td> <td>#{Stats.data[:action_controller].payload[:view_runtime].round(2).to_s}ms</td></tr>"
      str += "<tr><td class='firstColumn'>Partials Rendered:</td> <td> #{Stats.data[:partial_count] || 0}</td></tr>"
      str += "<tr class='alt'><td class='firstColumn'>Response Code:</td> <td> #{Stats.data[:action_controller].payload[:status].to_s}</td></tr>"
      str += "<tr><td class='firstColumn'>Controller:</td> <td> #{Stats.data[:action_controller].payload[:controller].to_s}</td></tr>"
      str += "<tr class='alt'><td class='firstColumn'>Action:</td> <td> #{Stats.data[:action_controller].payload[:action].to_s}</td></tr>"
      str += "<tr><td class='firstColumn'>Method:</td> <td> #{Stats.data[:action_controller].payload[:method].to_s}</td></tr>"
      str += "<tr class='alt'><td class='firstColumn'>Params:</td> <td> #{Stats.data[:action_controller].payload[:params]}</td></tr>"
      str += "<tr><td class='firstColumn'>Log:</td> <td> #{Stats.data[:log]}</td></tr>"
      str += "</table></div></div>"
    end
  end
end