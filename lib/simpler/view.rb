require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      case template
      when Hash then check_key_template
      else
        default_template(binding)
      end
    end

    private

    def check_key_template
      template[:plain] if template.has_key?(:plain)
    end

    def default_template(binding)
      template = File.read(template_path)
      @env['simpler.controller'].request.env['simpler.views'] = set_path
      ERB.new(template).result(binding)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      Simpler.root.join(VIEW_BASE_PATH, set_path)
    end

    def set_path
      path = template || [controller.name, action].join('/')
      "#{path}.html.erb"
    end
  end
end
