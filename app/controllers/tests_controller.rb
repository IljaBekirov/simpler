class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "Plain text response\nat #{@time}\n"
    status 200
  end

  def create
    @time = Time.now
    render plain: "Create request\n"
    status 201
  end

  def show
  end
end
