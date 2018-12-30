defmodule Docker.Request do

  @unix_socket Application.get_env(:docker, :unix_socket, "/var/run/docker.sock")
  @headers [{"Content-Type", "application/json"}]


  def get(endpoint, headers \\ [], opts \\ []) do
    request(endpoint, :get, "", headers, opts)
  end

  def post(endpoint, body \\ "", headers \\ [], opts \\ []) do
    request(endpoint, :post, body, headers, opts)
  end

  def delete(endpoint, headers \\ [], opts \\ []) do
    request(endpoint, :delete, "", headers, opts)
  end

  def put(endpoint, body \\ "", headers \\ [], opts \\ []) do
    request(endpoint, :put, body, headers, opts)
  end

  def patch(endpoint, body \\ "", headers \\ [], opts \\ []) do
    request(endpoint, :patch, body, headers, opts)
  end



  def request(endpoint, method, body, headers, opts) when is_map(body) do
    case Jason.encode(body) do
      {:ok, body} ->
        request(endpoint, method, body, headers, opts)

      {:error, error} ->
        {:error, error}
    end
  end

  def request(endpoint, method, body, headers, opts) when is_binary(body) do
    url = "http+unix://" <> URI.encode_www_form(@unix_socket)
    url = [url, endpoint] |> Path.join()

    HTTPoison.request(
      method,
      url,
      body,
      headers ++ @headers,
      opts
    )
    |> handle_response()
  end



  defp handle_response({:ok, %HTTPoison.Response{status_code: code, headers: headers, body: body}}) do
    case headers |> Map.new() do
      %{"Content-Type" => "application/json"} ->
        with {:ok, body} <- Jason.decode(body)
        do
          if round(code / 100) == 2 do
            {:ok, body}
          else
            {:error, {code, Map.get(body, "message")}}
          end
        end

      _ ->
        {:ok, body}
    end
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

end
