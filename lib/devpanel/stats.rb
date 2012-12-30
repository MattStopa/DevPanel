module DevPanel
  class Stats

    @@data ||= { log: "" }
    @@hidden = false
    @@x = 0
    @@y = 0

    def self.data
      @@data ||= { log: "" }
    end

    def self.delete_data
      @@data = {}
    end

    def self.x(val = @@x)
      return @@x if val.class != Fixnum && val.empty?
      @@x = val || 0
    end

    def self.y(val = @@y)
      return @@y if val.class != Fixnum && val.empty?
      @@y = val
    end

    def self.hidden(val = @@hidden)
      @@hidden ||= false
      @@hidden ||= val
    end

    def self.log(log)
      @@data[:log] ||= ""
      @@data[:log] += CGI::escapeHTML("#{log}")
      @@data[:log] += "<br>"
      @@data[:log] += CGI::escapeHTML("------")
      @@data[:log] += "<br>"
    end
  end
end
