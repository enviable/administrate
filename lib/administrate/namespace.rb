module Administrate
  class Namespace
    def initialize(namespace)
      @namespace = namespace.to_sym
    end

    def resources
      @resources ||= routes.keys.map do |path|
        Resource.new(namespace, path)
      end
    end

    def routes
      @routes ||= begin
        prefix = "#{namespace}/".freeze
        Rails.application.routes.routes.each_with_object({}) do |route, memo|
          next unless route.defaults[:controller]&.start_with?(prefix)

          controller = -route.defaults[:controller].delete_prefix(prefix)
          memo[controller] ||= []
          memo[controller] << route.defaults[:action]
        end
      end
    end

    def resources_with_index_route
      routes.select { |_resource, routes| routes.include?("index") }.keys
    end

    private

    attr_reader :namespace
  end
end
