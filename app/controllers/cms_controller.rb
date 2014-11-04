
class CmsController < ActionController::Metal

  include ActionController::Rendering


  append_view_path SqlTemplate::Resolver.new

  def respond
    render template: params[:page]
  end

end
