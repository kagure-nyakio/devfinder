defmodule DevfinderCoreTest do
  use ExUnit.Case, async: true
  import Mox

  alias Devfinder.Core.Dev

  @resp %{
    avatar_url: "https://avatars.githubusercontent.com/u/98824439?v=4",
    bio: "I am a developer who really enjoys puzzles and having fun solving everyday problems.",
    blog: "Not Available",
    company: "Not Available",
    created_at: "01 Feb 2022",
    followers: 0,
    following: 3,
    html_url: "https://github.com/kagure-nyakio",
    login: "kagure-nyakio",
    name: "Nyakio Muriuki J",
    public_repos: 38,
    twitter_username: "nyakio_muriuki",
    location: "Nairobi | Kenya",
 }

  @error_resp %{ error: "Not Found"}

  describe "find_dev/1" do
    test "successfully fetches developer's information given a username" do
      ApiClientBehaviourMock
      |> expect(:find_dev, fn _url ->
        {
          :ok,
          %Finch.Response{
            body: "{\"login\":\"kagure-nyakio\",\"id\":98824439,\"node_id\":\"U_kgDOBePw9w\",\"avatar_url\":\"https://avatars.githubusercontent.com/u/98824439?v=4\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/kagure-nyakio\",\"html_url\":\"https://github.com/kagure-nyakio\",\"followers_url\":\"https://api.github.com/users/kagure-nyakio/followers\",\"following_url\":\"https://api.github.com/users/kagure-nyakio/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/kagure-nyakio/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/kagure-nyakio/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/kagure-nyakio/subscriptions\",\"organizations_url\":\"https://api.github.com/users/kagure-nyakio/orgs\",\"repos_url\":\"https://api.github.com/users/kagure-nyakio/repos\",\"events_url\":\"https://api.github.com/users/kagure-nyakio/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/kagure-nyakio/received_events\",\"type\":\"User\",\"site_admin\":false,\"name\":\"Nyakio Muriuki J\",\"company\":null,\"blog\":\"\",\"location\":\"Nairobi | Kenya\",\"email\":null,\"hireable\":null,\"bio\":\"I am a developer who really enjoys puzzles and having fun solving everyday problems.\",\"twitter_username\":\"nyakio_muriuki\",\"public_repos\":36,\"public_gists\":0,\"followers\":0,\"following\":3,\"created_at\":\"2022-02-01T13:52:24Z\",\"updated_at\":\"2022-11-23T05:17:13Z\"}",
            status: 200
       }}
      end)

      assert @resp == Dev.find_dev("kagure-nyakio")
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
      assert @error_resp == Dev.find_dev("kagure-nyak")
    end
  end
end
