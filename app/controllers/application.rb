class Application < Merb::Controller
  before :find_categories
  def find_categories
    @categories = Category.all
  end
end