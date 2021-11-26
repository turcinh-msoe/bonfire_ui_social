defmodule Bonfire.UI.Social.Activity.NoteLive do
  use Bonfire.Web, :stateless_component
  import Bonfire.UI.Social.Integration

  prop object, :any
  prop activity, :any
  prop viewing_main_object, :boolean
  prop permalink, :string
  prop date_ago, :string
  prop showing_within, :any


  def post_content(object) do
    e(object, :post_content, object)
  end
end
