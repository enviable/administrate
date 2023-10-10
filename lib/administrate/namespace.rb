# frozen_string_literal: true

module Administrate
  class Namespace
    attr_reader :resources, :routes

    def initialize(namespace)
      @namespace = namespace.to_sym
      @routes = _routes
      @resources = _resources
    end

    def self.fetch(namespace)
      namespace = namespace.to_sym
      Engine.namespaces[namespace] ||= new(namespace)
    end

    def resources_with_index_route
      routes.select { |_resource, routes| routes[:actions].include?("index") }.keys
    end

    private

    def _resources
      routes.keys.map do |path|
        Resource.new(namespace, path)
      end
    end

    def _routes
      prefix = "#{namespace}/"
      Rails.application.routes.routes.each_with_object({}) do |route, memo|
        next unless route.defaults[:controller]&.start_with?(prefix)

        controller = route.defaults[:controller].delete_prefix(prefix)
        memo[controller] ||= { actions: Set.new, resolver: nil }
        memo[controller][:actions] ||= Set.new
        memo[controller][:actions] << route.defaults[:action]
      end
    end

    attr_reader :namespace
  end
end
