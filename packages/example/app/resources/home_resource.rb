class HomeResource < Lazuli::Resource
  def index
    Render "home", now: Time.now.to_f
  end
end
