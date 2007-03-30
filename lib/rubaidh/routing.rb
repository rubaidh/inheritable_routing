module Rubaidh
  module Routing
    
    module ResourcesExtensions
      def self.included(base)
        base.alias_method_chain :action_options_for, :resource_options
      end

      def action_options_for_with_resource_options(action, resource, method = nil)
        options = action_options_for_without_resource_options(action, resource, method)
        options[:conditions].merge!(resource.options[:conditions] || {})
        resource.options.merge(options)
      end

      # Unfortunately we can't just chain these methods, we need to overwrite
      # them to subtly change the behaviour of yielding to the block so that
      # options are passed in to them.  Other than that (and explicitly providing
      # the namespace to find the Resource and SingletonResource classes) they
      # are identical!
      private
        def map_resource(entities, options = {}, &block)
          resource = ActionController::Resources::Resource.new(entities, options)

          with_options :controller => resource.controller do |map|
            map_collection_actions(map, resource)
            map_default_collection_actions(map, resource)
            map_new_actions(map, resource)
            map_member_actions(map, resource)

            if block_given?
              with_options(options.merge({ :path_prefix => resource.nesting_path_prefix }), &block)
            end
          end
        end

        def map_singleton_resource(entities, options = {}, &block)
          resource = ActionController::Resources::SingletonResource.new(entities, options)

          with_options :controller => resource.controller do |map|
            map_collection_actions(map, resource)
            map_default_singleton_actions(map, resource)
            map_new_actions(map, resource)
            map_member_actions(map, resource)

            if block_given?
              with_options(options.merge({ :path_prefix => resource.nesting_path_prefix }), &block)
            end
          end
        end
    end
  end
end
