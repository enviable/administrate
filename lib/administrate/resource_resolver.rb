# frozen_string_literal: true

module Administrate
  class ResourceResolver
    attr_accessor :dashboard, :namespace, :resource_class,
                  :resource_name

    def initialize(namespace, resource_klass = nil)
      @namespace, resource_klass =
        if resource_klass.blank?
          namespace.split('/', 2)
        else
          [namespace, resource_klass]
        end
      @namespace = @namespace.to_sym
      resource_class_name = resource_klass.to_s.classify
      @resource_name = resource_class_name.gsub('::', '__').underscore.to_sym
      @resource_class = resource_class_name.safe_constantize
      @dashboard_class = ActiveSupport::Inflector.safe_constantize("#{@resource_class}Dashboard")
      @dashboard = @dashboard_class&.new
    end

    class << self
      def fetch(controller_path)
        namespace, resource_klass = controller_path.split('/', 2)

        routes_for_klass = Namespace.fetch(namespace).routes[resource_klass]
        if routes_for_klass.blank?
          # No routes for this resource to cache one, so we'll just return a resolver
          new(namespace, resource_klass)
        else
          routes_for_klass[:resolver] ||= new(namespace, resource_klass)
        end
      end
    end

    def resource_title
      @resource_class&.model_name&.human
    end
  end
end
