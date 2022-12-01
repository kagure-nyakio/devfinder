defmodule DevfinderCoreTest do
  use ExUnit.Case, async: true
  import Mox

  alias Devfinder.Core.Dev

  @resp %{
   avatar_url: "https://avatars.githubusercontent.com/u/26466961?v=4",
   bio: "This profile has no bio",
   blog: "Not Available",
   company: "Not Available",
   followers: 0,
   following: 0,
   html_url: "https://github.com/nyakio-muriuki",
   created_at: "16 Mar 2017",
   login: "nyakio-muriuki",
   name: "Not set",
   public_repos: 4,
   twitter_username: "Not Available"
 }

  @error_resp %{
    status: 404, 
    message: "Not Found"
  }
  
  describe "find_dev/1" do
    test "successfully fetches developer's information given a username" do
      ApiClientBehaviourMock
      |> expect(:find_dev, fn _url -> 
        {
          :ok,
          %Finch.Response{
            body: "{\"login\":\"nyakio-muriuki\",\"id\":26466961,\"node_id\":\"MDQ6VXNlcjI2NDY2OTYx\",\"avatar_url\":\"https://avatars.githubusercontent.com/u/26466961?v=4\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/nyakio-muriuki\",\"html_url\":\"https://github.com/nyakio-muriuki\",\"followers_url\":\"https://api.github.com/users/nyakio-muriuki/followers\",\"following_url\":\"https://api.github.com/users/nyakio-muriuki/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/nyakio-muriuki/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/nyakio-muriuki/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/nyakio-muriuki/subscriptions\",\"organizations_url\":\"https://api.github.com/users/nyakio-muriuki/orgs\",\"repos_url\":\"https://api.github.com/users/nyakio-muriuki/repos\",\"events_url\":\"https://api.github.com/users/nyakio-muriuki/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/nyakio-muriuki/received_events\",\"type\":\"User\",\"site_admin\":false,\"name\":null,\"company\":null,\"blog\":\"\",\"location\":null,\"email\":null,\"hireable\":null,\"bio\":null,\"twitter_username\":null,\"public_repos\":4,\"public_gists\":0,\"followers\":0,\"following\":0,\"created_at\":\"2017-03-16T17:41:23Z\",\"updated_at\":\"2017-04-26T12:23:46Z\"}",
            status: 200
       }}
      end)

      assert @resp == Dev.find_dev("nyakio-muriuki")
    end

    test "returns error message for developers not found" do
      ApiClientBehaviourMock
      |> expect(:find_dev, fn _url ->
        {:ok,
         %Finch.Response{
           body: "{\"message\":\"Not Found\",\"documentation_url\":\"https://docs.github.com/rest/reference/users#get-a-user\"}",
          status: 404
        }}
      end)
      assert @error_resp == Dev.find_dev("nyakio-muriuk")
    end
  end
end

