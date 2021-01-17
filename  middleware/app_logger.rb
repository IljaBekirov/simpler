require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(message(env))

    response
  end

  private

  def message(env)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']} \n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']} \n" \
    "Parameters: #{env['simpler.params']} \n" \
    "Response: #{env['simpler.status']} OK [#{env['simpler.headers']['Content-Type']}] #{env['simpler.views']}\n" \
  end
end
