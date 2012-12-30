require 'devpanel/extension.rb'
require 'devpanel/rails.rb'
require 'devpanel/middleware.rb'
require 'devpanel/stats.rb'

module DevPanel
  ActiveSupport.on_load(:action_controller) do
    include DevPanel::Panel
  end
end