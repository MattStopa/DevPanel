module DevPanel
  class Railtie < Rails::Railtie
    initializer "dev_panel.configure_rails_initialization" do
      unless Rails.env.production?

        Rails.application.middleware.use DevPanel::Middleware

        ActiveSupport::Notifications.subscribe(//) do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          puts event.inspect
        end

        ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Stats.delete_data if event.payload[:format] == :html
        end

        ActiveSupport::Notifications.subscribe('process_action.action_controller') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Stats.data[:action_controller] = event if event.payload[:format] == :html
        end

        ActiveSupport::Notifications.subscribe('render_partial.action_view') do |*args|
          Stats.data[:partial_count] ||= 0
          Stats.data[:partial_count] += 1
          event = ActiveSupport::Notifications::Event.new(*args)
          partial_name = event.payload[:identifier].split("app").last
          Stats.data[:partials] ||= {}
          Stats.data[:partials][partial_name] ||= 0
          Stats.data[:partials][partial_name] += 1
        end


        top = nil
        begin
          top = Rails.application.config.dev_panel_initial_top
        rescue
          top = 0
        end
       

        left = nil
        begin
          left = Rails.application.config.dev_panel_initial_left
        rescue
          left = 0
        end
        
        zindex = nil
        begin
          zindex = Rails.application.config.dev_panel_initial_zindex
        rescue
          zindex = 1000
        end
          
        DevPanel::Stats.top(top)
        DevPanel::Stats.left(left)
        DevPanel::Stats.zindex(zindex)
      end
    end
  end
end