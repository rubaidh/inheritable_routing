# Include hook code here
require 'rubaidh/routing'

ActionController::Routing::RouteSet::Mapper.send :include, Rubaidh::Routing::ResourcesExtensions
