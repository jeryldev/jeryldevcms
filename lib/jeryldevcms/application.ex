defmodule Jeryldevcms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JeryldevcmsWeb.Telemetry,
      Jeryldevcms.Repo,
      {DNSCluster, query: Application.get_env(:jeryldevcms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jeryldevcms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jeryldevcms.Finch},
      # Start a worker by calling: Jeryldevcms.Worker.start_link(arg)
      # {Jeryldevcms.Worker, arg},
      # Start to serve requests, typically the last entry
      JeryldevcmsWeb.Endpoint,
      {Beacon,
       sites: [
         [
           site: :jeryldev,
           repo: Jeryldevcms.Repo,
           endpoint: JeryldevcmsWeb.Endpoint,
           router: JeryldevcmsWeb.Router
         ]
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jeryldevcms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JeryldevcmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
