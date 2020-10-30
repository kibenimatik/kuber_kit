class KuberKit::Core::ServiceFactory
  AttributeNotSetError = Class.new(KuberKit::Error)

  def create(definition)
    service_attrs = definition.to_service_attrs

    if service_attrs.template_name.nil?
      raise AttributeNotSetError, "Please set template for service using #template method"
    end

    KuberKit::Core::Service.new(
      name:           service_attrs.name,
      template_name:  service_attrs.template_name,
      tags:           service_attrs.tags
    )
  end
end