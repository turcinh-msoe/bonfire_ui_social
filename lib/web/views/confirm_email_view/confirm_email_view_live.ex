defmodule  Bonfire.UI.Social.ConfirmEmailViewLive do
  use Bonfire.Web, :stateless_component

  prop flash, :any
  prop requested, :any
  prop error, :any
  prop form, :any

end
