defmodule DevfinderWeb.DevfinderLive do
  use DevfinderWeb, :live_view

  alias Devfinder.Client
  alias Devfinder.Username
  alias DevfinderWeb.IconComponents

  def render(assigns) do
    ~H"""
    <div class="flex justify-between items-center mb-8">
      <h1 class="font-bold text-[#222731] dark:text-[#fff] text-base">devfinder</h1>
      <div>
        <button
          class="uppercase font-bold tracking-widest dark:hidden flex gap-2 items-center"
          phx-click={JS.dispatch("toggle-theme")}
        >
          <span>Dark</span>
          <IconComponents.moon_icon />
        </button>

        <button
          class="uppercase font-bold tracking-widest hidden dark:flex dark:hover:text-[#90A4D4] dark:gap-2 dark:items-center"
          phx-click={JS.dispatch("toggle-theme")}
        >
          <span>Light</span>
          <IconComponents.sun_icon />
        </button>
      </div>
    </div>

    <.form
      for={@form}
      id="devfinder-form"
      phx-change="validate"
      phx-submit="search"
      class="py-2 px-3 max-w-2xl bg-white dark:bg-[#1E2A47] rounded-xl form-grid "
    >
      <IconComponents.search_icon class="search-icon" />
      <.input
        field={@form[:username]}
        type="text"
        placeholder="Search Github username.."
        class="search-input border-none"
        custom_class="text-sm border-none w-full h-full focus:ring-0 dark:bg-[#1E2A47]"
      />

      <div class="relative">
        <p
          :if={@show_errors}
          class="mr-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden absolute right-[100%] bottom-[5%]"
        >
          <%= @error %>
        </p>
        <.button phx-disable-with="..." class="bg-[#0079ff] text-white px-1 search-btn">
          Search
        </.button>
      </div>
    </.form>

    <div class="mt-8 px-8 py-6 max-w-2xl rounded-xl bg-white dark:bg-[#1E2A47] profile-grid">
      <img
        src={@dev_info["avatar_url"]}
        alt={@dev_info["name"]}
        class="h-16 w-16 rounded-full mr-2 profile-logo"
      />

      <div class="profile-header p-2">
        <h2 class="font-bold text-[#2b3442] dark:text-white text-lg tracking-wider profile-name">
          <%= @dev_info["name"] %>
        </h2>
        <.link href={@dev_info["html_url"]} class="text-[#0079ff] hover:opacity-75 profile-link">
          @<%= @dev_info["login"] %>
        </.link>
        <p class="profile-date">Joined <%= process_date(@dev_info["created_at"]) %></p>
        <p class="tracking-wider profile-bio"><%= @dev_info["bio"] %></p>
      </div>

      <div class="p-4 mt-2 rounded-md bg-[#f6f8ff] dark:bg-[#141D2F] flex gap-20 profile-stats">
        <p class="flex flex-col">
          <span class="text-sm dark:opacity-80 mb-3"> Repos </span>
          <span class="text-[#2b3442] dark:text-[#fff] font-bold">
            <%= @dev_info["public_repos"] %>
          </span>
        </p>
        <p class="flex flex-col ">
          <span class="text-sm dark:opacity-80 mb-3"> Followers </span>
          <span class="text-[#2b3442] dark:text-[#fff] font-bold"><%= @dev_info["followers"] %></span>
        </p>
        <p class="flex flex-col">
          <span class="text-sm dark:opacity-80 mb-3"> Following </span>
          <span class="text-[#2b3442] dark:text-[#fff] font-bold"><%= @dev_info["following"] %></span>
        </p>
      </div>

      <div class="p-4 mt-2 columns-2 profile-contact">
        <div class={["flex gap-2 items-center mb-3", @dev_info["location"] == "" && "opacity-50"]}>
          <IconComponents.location_icon />
          <p>
            <%= check_empty_response(@dev_info["location"]) %>
          </p>
        </div>

        <div class={["flex gap-2 items-center", @dev_info["blog"] == "" && "opacity-50"]}>
          <IconComponents.blog_icon />
          <p>
            <%= check_empty_response(@dev_info["blog"]) %>
          </p>
        </div>
        <div class={[
          "flex gap-2 items-center mb-3",
          @dev_info["twitter_username"] == "" && "opacity-50"
        ]}>
          <IconComponents.twitter_icon />
          <p>
            <%= check_empty_response(@dev_info["twitter_username"]) %>
          </p>
        </div>
        <div class={["flex gap-2 items-center", @dev_info["company"] == "" && "opacity-50"]}>
          <IconComponents.company_icon />
          <p>
            <%= check_empty_response(@dev_info["company"]) %>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_profile, "octocat")
     |> assign(:username, %Username{})
     |> assign(:error, "")
     |> assign(:show_errors, false)
     |> assign_dev_info("octocat")
     |> assign_form()}
  end

  def handle_event("validate", %{"username" => username_params}, socket) do
    %{assigns: %{username: username}} = socket

    changeset =
      username
      |> Username.changeset(username_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:show_errors, false)}
  end

  def handle_event("search", %{"username" => %{"username" => username}}, socket) do
    {
      :noreply,
      socket
      |> assign_dev_info(username)
    }
  end

  defp assign_dev_info(socket, dev_name) do
    case Client.find_dev(dev_name) do
      {:ok, "Not found"} ->
        socket
        |> assign(:error, "Not found")
        |> assign(:show_errors, true)

      {:ok, dev_info} ->
        socket
        |> assign(:dev_info, dev_info)
        |> assign(:current_profile, dev_name)
        |> assign(:show_errors, false)

      {:error, _reason} ->
        socket
        |> assign(:error, "Something went wrong")
        |> assign(:show_errors, true)
    end
  end

  defp assign_form(socket) do
    %{assigns: %{username: username}} = socket

    form =
      username
      |> Username.changeset()
      |> to_form()

    assign(socket, :form, form)
  end

  defp process_date(date) do
    [date, _time] = String.split(date, "T")

    [year, month, day] = String.split(date, "-")

    month =
      month
      |> String.to_integer()
      |> Timex.month_shortname()

    "#{day} #{month} #{year}"
  end

  defp check_empty_response(nil), do: "Not Available"

  defp check_empty_response(value) do
    case String.match?(value, ~r/^$/) do
      true -> "Not Available"
      false -> value
    end
  end


end
