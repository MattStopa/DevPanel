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
            background-color: #FACC9B;
          }

          #devPanelContainer td.firstColumn {
            width: 60px;
            font-weight: bold;
          }

          #devPanelContainer .alt {
            background-color: #FFF;
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
            z-index: 1;
          }
        </style>
      css_code
    end

    def html_containers
      <<-html_code
        <div id='partialList'>#{partial_list}</div>
        <div id="devPanelWindow" style="padding: 3px; color: #000; background-color: #F0F0F5; position: absolute; float: left; top: #{Stats.top.to_s}px; left: #{Stats.left.to_s}px;" >
        <div id="devPanelHider" style="width: 150px; text-align:center; border: solid 1px #fff"><a href="#">Show/Hide Stats</a> / <span style="font-size: 10px">#{Stats.data[:action_controller].duration.round(0).to_s}ms</span></div>
        <div id="devPanelContainer" style="width: 300px; padding-top: 20px">
      html_code
    end

    def stats(symbol)
      Stats.data[:action_controller].payload[symbol]
    end

    def html_table
      controller_time = (Stats.data[:action_controller].duration - stats(:view_runtime))
      table_rows = rowify([
        first_td("Total Time:")        + td("#{Stats.data[:action_controller].duration.round(2).to_s}ms"),
        first_td("Controller Time:")   + td("#{controller_time.round(2).to_s}ms"),
        first_td("View Time:")         + td("#{stats(:view_runtime).round(2).to_s}ms"),
        first_td("Partials Rendered:") + td(partial_count),
        first_td("Response Code:")     + td(stats(:status)),
        first_td("Controller:")        + td(stats(:controller)),
        first_td("Action:")            + td(stats(:action)),
        first_td("Method:")            + td(stats(:method)),
        first_td("Params:")            + td(stats(:params)),
        first_td("Log:")               + td(Stats.data[:log])
      ])

      "<table style='width: 290px; margin: auto; table-layout: fixed'>#{table_rows}</table></div></div>"
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