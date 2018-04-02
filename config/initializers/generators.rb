# Generator configuration
Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.jbuilder false
  g.test_framework :rspec,
    fxture: true,
    fixture_replacement: :factory_bot,
    helper_specs: false,
    view_specs: false,
    controller_specs: false,
    routing_specs: false
end
