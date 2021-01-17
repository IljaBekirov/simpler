module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path, env)
        @method == method && parse_path(path, env)
      end

      private

      def parse_path(path, env)
        params = {}
        route_path = @path.split('/')
        request_path = path.split('/')
        return false unless route_path.count == request_path.count

        request_path.each.with_index do |_, index|
          unless route_path[index] == request_path[index]
            match_data = route_path[index].match(/^:(.+)/)
            return false if match_data.nil?

            params[match_data[1].to_sym] = request_path[index]
          end
        end
        env['simpler.params'] = params
      end
    end
  end
end
