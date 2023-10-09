# frozen_string_literal: true

Administrate::Engine.routes.draw do
  ActiveSupport::Notifications.instrument('routes_loaded.administrate')
end
