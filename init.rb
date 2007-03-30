# Include hook code here
require 'rubaidh/routing'

ActionController::Routing::RouteSet::Mapper.send :include, Orkell::Routing::ResourcesExtensions
