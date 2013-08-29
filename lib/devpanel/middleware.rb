module DevPanel
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["REQUEST_URI"] =~ /__DevPanel\/main/
        [200, { "Content-Type" => "text/html; charset=utf-8" }, [dev_panel_output]]
      elsif env["REQUEST_URI"] =~ /__DevPanel\/set_options/
         params = Rack::Utils.parse_query(env['QUERY_STRING'], "&")
         Stats.set_by_params(params)
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, ["#{Stats.show?} #{Stats.left} #{Stats.top}"]]
      else
        @app.call(env)
      end
    end

    def dev_panel_output
      (css + html_containers + html_table).html_safe
    end

    def css
      <<-css_code
        <style>
          table {
            width: 100%
          }

          #devPanelWindow {
            border-radius: 3px;
            margin-bottom: 2px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.03), 1px 1px 0 rgba(0, 0, 0, 0.05), -1px 1px 0 rgba(0, 0, 0, 0.05), 0 0 0 4px rgba(0, 0, 0, 0.04);
            font-family: menlo, lucida console, monospace;
            border: 3px solid #29488B;
            z-index: 500000000;
            padding: 3px; 
            color: #000; 
            background-color: #F0F0F5; 
            position: absolute; 
            float: left;             
          }

          #devPanelHider {
            background: #5366EB;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.3);
            font-family: arial;
            font-size: 12.8px;
            overflow: hidden;
            padding: 6px 10px;
            border: solid 1px #CCC;
            border-bottom: 0;
            border-top-left-radius: 2px;
            border-top-right-radius: 2px;
            text-align:left; 
            border: solid 1px #fff;
          }

          .hider-color {
            color: #fff
          }

          #devPanelContainer {
            font-family: menlo, lucida console, monospace;
            background-color: #fff;
            box-shadow: inset 3px 3px 3px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(0, 0, 0, 0.1);
            width: 300px;
            padding: 2px           
          }

          #devPanelContainer td {
            font-family: arial;
            font-size: 12px;
            font-weight: normal;
            padding: 5px;
            overflow: auto;
            letter-spacing: 1.5px
          }

          #devPanelContainer tr {
            background-color: #2E2E2E;
            color: rgb(238, 238, 238);
            border-bottom: 1px solid #4B4444;
          }

          #devPanelContainer .alt {
            background-color: #000000;
            color: rgb(238, 238, 238);
            border-bottom: 1px solid #4B4444;
          }

          #devPanelContainer td.firstColumn {
            width: 90px;
            font-weight: bold;
          }

          #viewTime {
            font-size: 10px;
            text-decoration: underline;
          }

          #partialList {
            position: absolute;
            top: 0px;
            left: 0px;
            background: #F1F1F1;
            border: 2px solid #000;
            background-color: #fff;
            box-shadow: inset 3px 3px 3px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(0, 0, 0, 0.1);
            font-family: arial;
            font-size: 10px;
            overflow: hidden;
            padding: 6px 10px;
            border-top-left-radius: 2px;
            border-top-right-radius: 2px;
            display: none;
            z-index: 500000001;
          }

          .green { background: #21D61A !important}
          .yellow { background: #BEBE00 !important }
          .orange { background: #F0A811 !important }
          .red { background: #B90000 !important }

        </style>
      css_code
    end

    def html_containers
      <<-html_code
        <div id='partialList'>#{partial_list}</div>
        <div id="devPanelWindow" style="top: #{Stats.top.to_s}px; left: #{Stats.left.to_s}px;" >
        <div id="devPanelHider" class="#{heat_color}"><a class="hider-color" href="#">#{stats(:controller)}##{stats(:action)}</a> / <span class="hider-color" style="font-size: 10px">#{Stats.data[:action_controller].duration.round(0).to_s}ms</span></div>
        <div id="devPanelContainer">
      html_code
    end

    def heat_color
      time = Stats.data[:action_controller].duration.round(0)
      if(time < 500)
         "green"
      elsif(time < 1500)
         "yellow"
      elsif(time < 2500)
         "orange"
      else
         "red"
       end

    end

    def stats(symbol)
      Stats.data[:action_controller].payload[symbol]
    end

    def html_table
      table_rows = rowify([
        first_td("Total:")        + td("#{Stats.total_duration.to_s}ms"),
        first_td("Controller:")   + td("#{Stats.controller_duration.to_s}ms (#{Stats.controller_duration_percent}%)"),
        first_td("View:")         + td("#{Stats.view_duration.to_s}ms (#{Stats.view_duration_percent}%)"),
        first_td("Partials:") + td(partial_count),
        first_td("Response:")     + td(stats(:status)),
        first_td("Controller:")        + td(stats(:controller)),
        first_td("Action:")            + td(stats(:action)),
        first_td("Method:")            + td(stats(:method)),
        first_td("Params:")            + td(stats(:params)),
        first_td("Log:")               + td(Stats.data[:log])
      ])

      "<table style='margin: auto; table-layout: fixed'>#{table_rows}</table></div></div>"
    end

    def partial_count
      "<div id='viewTime'>#{Stats.data[:partial_count] || 0}</div>"
    end

    def partial_list
      str = ""
      Stats.data[:partials].each_pair {|k,v| str << "#{k}: #{Stats.data[:partials][k]}<br>" } if Stats.data[:partials].present?
      str
    end

    def tr(content = "", klass="")
      "<tr class=#{klass}>#{content}</tr>"
    end

    def td(content = "")
      "<td>#{content}</td>"
    end

    def first_td(content = "")
      "<td class='firstColumn'>#{content}</td>"
    end

    def rowify(arr)
      result = ""
      arr.each_with_index do |data, index|
        result += tr(data, index.even? ? "alt" : "")
      end
      result
    end

  end
end