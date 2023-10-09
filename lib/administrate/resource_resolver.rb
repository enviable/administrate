# frozen_string_literal: true

module Administrate
  class ResourceResolver
    attr_accessor :dashboard_class, :namespace, :resource_class,
                  :resource_name, :resource_title

    def initialize(controller_path)
      @controller_path = controller_path
      namespace, resource_klass = controller_path.split("/", 2)
      @namespace = namespace.to_sym
      resource_class_name = resource_klass.classify
      @resource_name = resource_class_name.gsub("::", "__").underscore.to_sym
      @resource_class = resource_class_name.safe_constantize
      @dashboard_class = ActiveSupport::Inflector.safe_constantize("#{@resource_class}Dashboard")
      @resource_title = @resource_class&.model_name&.human
    end
  end
end
