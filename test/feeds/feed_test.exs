defmodule Bonfire.UI.Social.Feeds.FeedActivityTest do

  use Bonfire.UI.Social.ConnCase

  alias Bonfire.Social.Fake
  alias Bonfire.Me.Users
  alias Bonfire.Social.{Boosts, Likes, Follows, Posts}
  alias Bonfire.Repo

  def publish_multiple_times(msg, user, n) when n > 0 do
    {:ok, post} = Posts.publish(user, msg)
    IO.inspect(n)
    publish_multiple_times(msg, user, n-1)
  end
  
  def publish_multiple_times(_msg, _user, 0) do
    :ok
  end

  test "As a user I want to see the whole amount of activities if they are less than 10" do
    # Create alice user
    account = fake_account!()
    alice = fake_user!(account)
    # Create bob user
    account2 = fake_account!()
    bob = fake_user!(account2)

    total_posts = 8
    attrs = %{to_circles: [:guest], post_content: %{summary: "summary", name: "test post name", html_body: "first post"}}
    publish_multiple_times(attrs, bob, total_posts)
    feed = Bonfire.Social.FeedActivities.my_feed(bob)
    assigns = [feed: feed.edges, feed_id: "Bob's feed", page_title: "test", page_info: [], showing_within: nil]
    assert doc = render_surface(Bonfire.UI.Social.FeedViewLive, assigns)
    assert doc
       |> Floki.parse_fragment
       |> elem(1)
       |> Floki.find("article")
       |> length == total_posts
  end

  test "As a user I want to see up to 10 activities when viewing a feed" do
    # Create alice user
    account = fake_account!()
    alice = fake_user!(account)
    # Create bob user
    account2 = fake_account!()
    bob = fake_user!(account2)

    total_posts = 13
    attrs = %{to_circles: [:guest], post_content: %{summary: "summary", name: "test post name", html_body: "first post"}}
    publish_multiple_times(attrs, bob, total_posts)
    feed = Bonfire.Social.FeedActivities.my_feed(bob)
    assigns = [feed: feed.edges, feed_id: "Bob's feed", page_title: "test", page_info: [], showing_within: nil]
    assert doc = render_surface(Bonfire.UI.Social.FeedViewLive, assigns)
    assert doc
       |> Floki.parse_fragment
       |> elem(1)
       |> Floki.find("article")
       |> length == 10
  end

  test "As a user I cannot see the load more button if there are less than 10 activities in feed" do
    # Create alice user
    account = fake_account!()
    alice = fake_user!(account)
    # Create bob user
    account2 = fake_account!()
    bob = fake_user!(account2)

    total_posts = 4
    attrs = %{to_circles: [:guest], post_content: %{summary: "summary", name: "test post name", html_body: "first post"}}
    publish_multiple_times(attrs, bob, total_posts)
    feed = Bonfire.Social.FeedActivities.my_feed(bob)
    IO.inspect(feed.page_info)
    assigns = [feed: feed.edges, feed_id: "Bob's feed", page_title: "test", page_info: feed.page_info, showing_within: nil]
    assert doc = render_surface(Bonfire.UI.Social.FeedViewLive, assigns)
    assert doc
      |> Floki.parse_fragment
      |> elem(1)
      |> Floki.find("[data-id=load_more]")
      |> Floki.text() =~ ""
  end

  test "As a user I want to click on the load more button to load more activities" do
    # Create alice user
    account = fake_account!()
    alice = fake_user!(account)
    # Create bob user
    account2 = fake_account!()
    bob = fake_user!(account2)

    total_posts = 12
    attrs = %{to_circles: [:guest], post_content: %{summary: "summary", name: "test post name", html_body: "first post"}}
    publish_multiple_times(attrs, bob, total_posts)
    feed = Bonfire.Social.FeedActivities.my_feed(bob)
    IO.inspect(feed.page_info)
    assigns = [feed: feed.edges, feed_id: "Bob's feed", page_title: "test", page_info: feed.page_info, showing_within: nil]
    assert doc = render_surface(Bonfire.UI.Social.FeedViewLive, assigns)
    assert doc
      |> Floki.parse_fragment
      |> elem(1)
      |> Floki.find("[data-id=load_more]")
      |> Floki.text() =~ "Load more"
  end

  test "As a user when I create a new activity, it appears instantly in the feed" do
  end

  test "Logged-in home activities feed shows the user inbox" do
  end

  test "Logged-out Home activities feed shows the instance outbox filtered by public boundary" do
  end

  test "Local feed shows the instance outbox filtered by local boundary" do
  end

  # Which activities? 
  test "Federation feed shows federated outbox" do
  end

  test "User timeline feed shows the user outbox" do
  end

  test "User posts feed only shows posts that are not replies" do
  end

  test "User likes feed only shows the like activities" do
  end

  test "Notification feed shows: likes, mentions, boosts, follows, reply activities" do
  end

  test "If Alice likes Bob's post, the liked activity should appear only in bob's notification feed" do
  end

  test "When Alice follows Bob, the followed activity appears only in bob's notification feed" do
  end
  
end