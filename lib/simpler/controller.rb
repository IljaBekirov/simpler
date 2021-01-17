require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @request.env['simpler.status'] = @response.status
      @request.env['simpler.headers'] = @response.headers
      @response.finish
    end

    private

    def status(number)
      @response.status = number
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def render(template)
      edit_headers(template) if template.is_a?(Hash)

      @request.env['simpler.template'] = template
    end

    def edit_headers(template)
      headers['Content-Type'] = 'text/plain' if template.has_key?(:plain)
    end

    def headers
      @response.headers
    end
  end
end
