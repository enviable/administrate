module DashboardHelpers
  def displayed(resource)
    "#{resource.class}Dashboard"
      .constantize
      .new
      .display_resource(resource)
  end
end
