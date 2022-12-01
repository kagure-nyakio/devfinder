defmodule Devfinder.Type do
  @type user_info :: %{
    avatar_url: String.t,
    name: String.t,
    login: String.t,
    html_url: String.t,
    created_at: String.t,
    bio: String.t,
    public_repos: integer,
    followers: integer,
    following: integer,
    twitter_username: String.t,
    blog: String.t,
    company: String.t
  }

  @type github_error :: %{
      status: integer,
      message: String.t
  }

end

