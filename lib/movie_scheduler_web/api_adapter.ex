defmodule MovieSchedulerWeb.API do
  use HTTPoison.Base

  @endpoint Application.get_env(:movie_scheduler, :api_endpoint)

  def process_request_body(body), do: body
  def process_request_headers(headers), do: headers
  def process_request_options(options), do: options
  def process_response_chunk(chunk), do: chunk
  def process_headers(headers), do: headers
  def process_response_status_code(status_code), do: status_code

  def process_request_url(url) do
    @endpoint <> url
  end

  def process_response_body(body) do
    %{"data" => data} = Poison.decode!(body)
    data
  end
end