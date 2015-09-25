if defined?(UnionStation)
  UnionStationHooks.initialize!
elsif defined?(PhusionPassenger)
  PhusionPassenger.install_framework_extensions!
end
