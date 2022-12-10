defmodule FinderClientWeb.FinderView do
  use FinderClientWeb, :view

  def find_dev(conn) do
    form_for(conn, Routes.finder_path(conn, :new), [as: "fetch_info", method: :post], fn f -> 
      [
        text_input(f, :username, placeholder: "Search Github username..."),
        submit("Search")
      ]

    end)
  end

  def dev_info(%{message: message}) do
    "<h2>Sorry: #{message}</h2>" |> raw()
  end

  def dev_info(dev_info) do
  """
    <div>
      <img src=#{dev_info.avatar_url} alt="#{dev_info.name} avatar">
        <div>
          <h2>#{dev_info.name}</h2>
          <p><a href=#{dev_info.html_url}>@#{dev_info.login}</a></p>
          <p>#{dev_info.created_at}</p>
        </div>
      </div>

      <p> #{dev_info.bio} </p>

        <p>Repos</p>
        <p>Followers</p>
        <p>Following</p>
        <p>#{dev_info.public_repos}</p>
        <p>#{dev_info.followers}</p>
        <p>#{dev_info.following}</p>
        <div>

          <ul>
            <li>#{dev_info.blog}</li>
            <li>#{dev_info.twitter_username}</li>
            <li>#{dev_info.company}</li>
          </ul>
        
      </div>
    """ |> raw()
  end
end
