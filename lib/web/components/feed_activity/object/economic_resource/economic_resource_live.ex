defmodule Bonfire.UI.Social.Activity.EconomicResourceLive do
  use Bonfire.Web, :stateless_component
  import Bonfire.UI.Social.Integration

  prop object, :map

  def update(assigns, socket) do
    # TODO: run these preloads when fetching the feed, rather than n+1
    {:ok, socket |>
      assigns_merge(assigns,
        object: assigns.object
        |> preloads() #|> IO.inspect
      )
    }
  end

  def resource_preloads(), do: [:image, :current_location, onhand_quantity: [:unit], accounting_quantity: [:unit]]

  def preloads(object) do
    object
    |> repo().maybe_preload(resource_preloads())
  end
end
