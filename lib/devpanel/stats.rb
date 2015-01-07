module DevPanel
  class Stats
    class << self
      def defaults
        {
          data: { log: '' },
          visible: 'false',
          left: 0,
          top: 0,
          zindex: 1000
        }
      end

      def set_defaults
        defaults.each_pair do |key, value|
          self.class_variable_set(:"@@#{key}", value)
        end
      end

      def set_by_params(params)
        ['visible', 'left', 'top', 'zindex'].each do |str|
          Stats.send(str, params[str]) if params[str]
        end
      end

      def method_missing(*arr)
        if [:left, :top, :zindex].include?(arr.first)
          return self.class_variable_get(:"@@#{arr.first}") if arr.size < 2 || (invalid_number?(arr.last.to_i))
          self.class_variable_set(:"@@#{arr.first}", (arr.last || defaults[arr.first]))
          return self.class_variable_get(:"@@#{arr.first}")
        end
      end

      def data
        @@data
      end

      def visible(val = @@visible)
        @@visible = val
      end

      def invalid_number?(val)
        val.class != Fixnum || val.nil?
      end

      def total_duration
        data[:action_controller].duration.round(2)
      end

      def controller_duration
        (data[:action_controller].duration - stats(:view_runtime)).round(2)
      end

      def view_duration
        stats(:view_runtime).round(2)
      end

      def controller_duration_percent
        ((controller_duration / total_duration) * 100).round(0)
      end

      def view_duration_percent
        ((view_duration / total_duration) * 100).round(0)
      end

      def stats(symbol)
        data[:action_controller].payload[symbol]
      end

      def delete_data
        self.data = {}
      end

      def show?
        @@visible == "true"
      end

      def log(log = nil)
        return data[:log] unless log
        data[:log] ||= ""
        data[:log] += "<div style='border-bottom: 1px black solid'>"
        data[:log] += CGI::escapeHTML("#{log}")
        data[:log] += "</div>"
      end

      def time(tag = nil)
        start = Time.now
        yield
        time_spent = ((Time.now - start)*1000).round(2)
        self.log("#{tag}: Time Elapsed: #{time_spent}ms")
      end
    end

    self.set_defaults
  end
end
