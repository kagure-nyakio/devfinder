defmodule Devfinder.ClientTest do
  use ExUnit.Case, async: true

  import Mox

  alias Devfinder.Client

  setup :verify_on_exit!

  @valid_response %{
    "avatar_url" => "https://avatars.githubusercontent.com/u/98824439?v=4",
    "bio" =>
      "Lorem Ipsum",
    "blog" => "",
    "company" => "@optimumBA ",
    "created_at" => "2022-02-01T13:52:24Z",
    "email" => nil,
    "events_url" => "https://api.github.com/users/octocat/events{/privacy}",
    "followers" => 2,
    "followers_url" => "https://api.github.com/users/octocat/followers",
    "following" => 6,
    "following_url" => "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url" => "https://api.github.com/users/octocat/gists{/gist_id}",
    "gravatar_id" => "",
    "hireable" => nil,
    "html_url" => "https://github.com/octocat",
    "id" => 98_824_439,
    "location" => "Nairobi | Kenya",
    "login" => "octocat",
    "name" => "OctoCat",
    "node_id" => "U_kgDOBePw9w",
    "organizations_url" => "https://api.github.com/users/octocat/orgs",
    "public_gists" => 0,
    "public_repos" => 7,
    "received_events_url" => "https://api.github.com/users/octocat/received_events",
    "repos_url" => "https://api.github.com/users/octocat/repos",
    "site_admin" => false,
    "starred_url" => "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url" => "https://api.github.com/users/octocat/subscriptions",
    "twitter_username" => "nyakio_muriuki",
    "type" => "User",
    "updated_at" => "2023-12-21T06:48:10Z",
    "url" => "https://api.github.com/users/octocat"
  }

  describe "find_dev/1" do
    test "returns github user profile given a name" do
      Devfinder.Client.Mock
      |> expect(:find_dev, fn _username ->
        {:ok, @valid_response}
      end)

      assert {:ok, @valid_response} =  Client.find_dev("octocat")
    end
  end
end
