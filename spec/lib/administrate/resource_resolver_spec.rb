require "rails_helper"

describe Administrate::ResourceResolver do
  it "handles global-namespace models" do
    class UserDashboard; end
    class User < ApplicationRecord; self.abstract_class = true; end
    resolver = Administrate::ResourceResolver.new("admin/users")

    expect(resolver.namespace).to eq(:admin)
    expect(resolver.dashboard).to be_a UserDashboard
    expect(resolver.resource_class).to eq(User)
    expect(resolver.resource_title).to eq("User")
    expect(resolver.resource_name).to eq(:user)

  ensure
    remove_constants :UserDashboard
    remove_constants :User
  end

  it "handles namespaced models" do
    module Library
      class Book < ApplicationRecord; self.abstract_class = true; end
      class BookDashboard; end
    end

    resolver = Administrate::ResourceResolver.new("admin/library/books")
    expect(resolver.namespace).to eq(:admin)
    expect(resolver.dashboard).to be_a Library::BookDashboard
    expect(resolver.resource_class).to eq(Library::Book)
    expect(resolver.resource_title).to eq("Book")
    expect(resolver.resource_name).to eq(:library__book)

    translations = {
      activerecord: {
        models: {
          "library/book": "Library Book",
        },
      },
    }
    with_translations(:en, translations) do
      resolver = Administrate::ResourceResolver.new("admin/library/books")
      expect(resolver.resource_title).to eq("Library Book")
    end

  ensure
    remove_constants :Library
  end

  it "handles plural namespaced models" do
    module Libraries
      class Book < ApplicationRecord; self.abstract_class = true; end
      class BookDashboard; end;
    end

    resolver = Administrate::ResourceResolver.new("admin/libraries/books")

    expect(resolver.namespace).to eq(:admin)
    expect(resolver.dashboard).to be_a Libraries::BookDashboard
    expect(resolver.resource_class).to eq(Libraries::Book)
    expect(resolver.resource_title).to eq("Book")
    expect(resolver.resource_name).to eq(:libraries__book)

  ensure
    remove_constants :Libraries
  end
end
