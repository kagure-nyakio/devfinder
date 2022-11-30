defmodule DevfinderCoreTest do
  use ExUnit.Case, async: true
  import Mox

  alias Devfinder.Core.Dev

  @resp %Devfinder.Core.Dev{
   avatar_url: "https://avatars.githubusercontent.com/u/26466961?v=4",
   bio: "This profile has no bio",
   blog: "Not Available",
   company: "Not Available",
   followers: 0,
   following: 0,
   github_url: "https://github.com/nyakio-muriuki",
   joined_on: "16 Mar 2017",
   login: "nyakio-muriuki",
   name: "Not set",
   public_repos: 4,
   twitter_username: "Not Available"
 }

  @error {:error, {404, "Not Found"}}
  
  describe "find_dev/1" do
    test "successfully fetches developer's information given a username" do
      ApiClientBehaviourMock
      |> expect(:find_dev, fn _url -> 
        %{
          "login" => "nyakio-muriuki",
          "id" => 26466961,
          "avatar_url" => "https://avatars.githubusercontent.com/u/26466961?v=4",
          "html_url" => "https://github.com/nyakio-muriuki",
          "name" => nil,
          "company" => nil,
          "blog" => "",
          "location" => nil,
          "email" => nil,
          "bio" => nil,
          "twitter_username" => nil,
          "public_repos" => 4,
          "followers" => 0,
          "following" => 0,
          "created_at" => "2017-03-16T17:41:23Z",
        }
      end)
      result = {:ok, @resp}
      assert result == Dev.find_dev("nyakio-muriuki")
    end

    test "returns error message for developers not found" do
      ApiClientBehaviourMock
      |> expect(:find_dev, fn _url ->
        %{
          "message" => "Not Found",
          "status"  => 404
        }
      end)
      assert @error == Dev.find_dev("nyakio-muriuk")
    end
  end
end

