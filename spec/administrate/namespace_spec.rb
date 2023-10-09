require "rails_helper"
require "administrate/namespace"

describe Administrate::Namespace do
  describe "#resources" do
    it "searches the routes for resources in the namespace" do
      Rails.application.routes.draw do
        namespace(:admin) { resources :customers }
        resources :administrators
      end

      namespace = Administrate::Namespace.new(:admin)

      expect(namespace.resources.map(&:to_sym)).to eq [:customers]
    ensure
      reset_routes
    end
  end

  describe "#resources_with_index_route" do
    it "returns only resources with the index route" do
      Rails.application.routes.draw do
        namespace(:admin) do
          resources :customers
          resources :products, only: [:show]
        end
      end
      namespace = Administrate::Namespace.new(:admin)

      expect(namespace.resources_with_index_route).to eq ["customers"]
    ensure
      reset_routes
    end

    it "returns a list of unique resources" do
      Rails.application.routes.draw do
        namespace(:admin) do
          resources :customers
          resources :products, only: [:show]

          root to: "customers#index"
        end
      end
      namespace = Administrate::Namespace.new(:admin)

      expect(namespace.resources_with_index_route).to eq ["customers"]
    ensure
      reset_routes
    end
  end
end
