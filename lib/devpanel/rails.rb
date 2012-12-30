module DevPanel
  class Railtie < Rails::Railtie
    initializer "dev_panel.configure_rails_initialization" do
      unless Rails.env.production?
        Rails.application.middleware.use DevPanel::Middleware

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
        end

      end
    end
  end
end