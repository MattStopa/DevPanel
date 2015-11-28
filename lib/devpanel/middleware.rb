module DevPanel
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request_uri = env["REQUEST_URI"]
      params = Rack::Utils.parse_query(env['QUERY_STRING'], "&")

      if request_uri =~ /__DevPanel\/main/
        [200, { "Content-Type" => "text/html; charset=utf-8" }, [dev_panel_output]]
      elsif request_uri =~ /__DevPanel\/set_options/
        Stats.set_by_params(params)
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, ["#{Stats.show?} #{Stats.left} #{Stats.top}"]]
      elsif request_uri =~ /__DevPanel\/console/
        query = params["query"]
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, ["#{CGI::escapeHTML(eval(query).to_s)}"]]
      elsif request_uri =~ /__DevPanel\/assets/
        data = File.read(File.dirname(__FILE__) + '/assets/' + request_uri.split('/__DevPanel/assets/').last)
        [200, { "Content-Type" => "text/plain; charset=utf-8" }, [data]]
      elsif request_uri =~ /__DevPanel\/file/
        filename = request_uri.split('/__DevPanel/file/').last
        data = File.read('/' + filename)
        template = ERB.new File.new("#{File.dirname(__FILE__)}/views/file_viewer.html.erb").read, nil, "%"
        os = OpenStruct.new(data: stats(:data), filename: filename)
        result = template.result(os.instance_eval { binding })
        [200, { "Content-Type" => "text/html; charset=utf-8" }, [result]]
      else
        @app.call(env)
      end
    end

    def dev_panel_output
      template = ERB.new File.new("#{File.dirname(__FILE__)}/views/header.html.erb").read, nil, "%"
      os = OpenStruct.new(
        controller: stats(:controller),
        action: stats(:action),
        status: stats(:status),
        partial_count: partial_count,
        total_duration: Stats.total_duration.round(0).to_s,
        controller_duration: Stats.controller_duration.round(0).to_s,
        controller_percent: Stats.controller_duration_percent.to_s,
        view_duration: Stats.view_duration.to_s,
        view_duration_percent: Stats.view_duration_percent,
        log: Stats.data[:log],
        partial_list: Hash[Stats.data[:partials].to_a.reverse],
        partial_paths: Stats.data[:partial_paths] || [],
        params: stats(:params)
        )
      template.result(os.instance_eval { binding }).html_safe
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

    def partial_count
      Stats.data[:partial_count] || 0
    end
  end
end