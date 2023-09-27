module Administrate
  class Namespace
    def initialize(namespace)
      @namespace = namespace.to_sym
    end

    def resources
      @resources ||= routes.map(&:first).uniq.map do |path|
        Resource.new(namespace, path)
      end
    end

    def routes
      @routes ||= begin
        regex = %r{^#{namespace}/(.*)}
        Rails.application.routes.routes.filter_map do |route|
          route.defaults[:controller]&.slice(regex, 1)&.yield_self do |controller|
            [controller, route.defaults[:action]]
          end
        end
      end
    end

    def resources_with_index_route
      routes.select { |_resource, route| route == "index" }.map(&:first).uniq
    end

    private

    attr_reader :namespace
  end
end
