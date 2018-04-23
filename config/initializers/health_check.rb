HealthCheck.setup do |config|
  config.full_checks -= %w[email]
end
