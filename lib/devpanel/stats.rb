module DevPanel
  class Stats

    def self.set_defaults
      @@data    ||= { log: '' }
      @@visible = 'false'
      @@left    = 0
      @@top     = 0
      @@zindex  = 1000
    end

    set_defaults

    def self.set_by_params(params)
      ['visible', 'left', 'top', 'zindex'].each do |str|
        Stats.send(str, params[str]) if params[str]
      end
      Stats.log(' ')
    end

    def self.data
      @@data ||= { log: '' }
    end

    def self.left(val = @@left)
      return @@left if val.class != Fixnum && val.empty?
      @@left = val || 0
    end

    def self.top(val = @@top)
      return @@top if val.class != Fixnum && val.empty?
      @@top = val
    end

    def self.zindex(val = @@zindex)
      return @@zindex if val.class != Fixnum && val.empty?
      @@zindex = val || 1000
    end

    def self.visible(val = @@visible)
      @@visible = val
    end

    def self.total_duration
      data[:action_controller].duration.round(2)
    end

    def self.controller_duration
      (data[:action_controller].duration - stats(:view_runtime)).round(2)
    end

    def self.view_duration
      stats(:view_runtime).round(2)
    end

    def self.controller_duration_percent
      ((controller_duration / total_duration) * 100).round(0)
    end

    def self.view_duration_percent
      ((view_duration / total_duration) * 100).round(0)
    end

    def self.stats(symbol)
      data[:action_controller].payload[symbol]
    end


    def self.delete_data
      @@data = {}
    end

    def self.show?
      @@visible == "true"
    end

    def self.log(log)
      @@data[:log] ||= ""
      @@data[:log] += "<div style='border-bottom: 1px black solid'>"
      @@data[:log] += CGI::escapeHTML("#{log}")
      @@data[:log] += "</div>"
    end

    def self.time
      start = Time.now
      yield
      time_spent = ((Time.now - start)*1000).round(2)
      self.log("Time Elapsed: #{time_spent}ms")
    end

  end
end
