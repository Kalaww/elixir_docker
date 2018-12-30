defmodule Docker.Container do
  import Docker.Request


  def list(params \\ []) do
    get("/containers/json", [], params: params)
  end

  def list!(params \\ []) do
    case list(params) do
      {:ok, result} -> result
      {:error, error} -> raise error
    end
  end

  def create(config) do
    params =
      case Map.fetch(config, :name) do
        {:ok, name} -> [{"name", name}]
        :error -> []
      end

    post("/containers/create", config, [], params: params)
  end

  def inspect(container_id) do
    get("/containers/#{container_id}/json")
  end

  def top(container_id, ps_args \\ nil) do
    params =
      if is_binary(ps_args), do: [{"ps_args", ps_args}], else: []

    get("/containers/#{container_id}/top", [], params: params)
  end

  def logs(container_id, params \\ []) do
    get("/containers/#{container_id}/logs", [], params: params)
  end

  def changes(container_id) do
    get("/containers/#{container_id}/changes")
  end

  def start(container_id, params \\ []) do
    post("/containers/#{container_id}/start", "", [], params: params)
  end

  def stop(container_id, params \\ []) do
    post("/containers/#{container_id}/stop", "", [], params: params)
  end

  def restart(container_id, params \\ []) do
    post("/containers/#{container_id}/restart", "", [], params: params)
  end

  def kill(container_id, signal \\ "SIGKILL") do
    post("/containers/#{container_id}/kill", "", [], params: [{"signal", signal}])
  end

  def update(container_id, config) do
    post("/containers/#{container_id}/update", config)
  end

  def rename(container_id, name) do
    post("/containers/#{container_id}/rename", "", [], params: [{"name", name}])
  end

  def pause(container_id) do
    post("/containers/#{container_id}/pause")
  end

  def unpause(container_id) do
    post("/containers/#{container_id}/unpause")
  end

  def wait(container_id) do
    post("/containers/#{container_id}/wait")
  end

  def remove(container_id) do
    delete("/containers/#{container_id}")
  end

  def exec(container_id, exec_create_params, exec_start_params) do
    with  {:ok, exec_id} <- Docker.Exec.create(container_id, exec_create_params)
    do
      Docker.Exec.start(exec_id, exec_start_params)
    end
  end

  def put_archive(container_id, path, tar_file_stream, no_overwrite_dir_non_dir) do
    params = [
      {"path", path},
      {"noOverwriteDirNonDir", no_overwrite_dir_non_dir}
    ]
    put("/containers/#{container_id}/archive", tar_file_stream, [], params: params)
  end

  def get_archive(container_id, path) do
    get("/containers/#{container_id}/archive", [], params: [{"path", path}])
  end

  def prune(filters \\ %{}) do
    post("/containers/prune", "", [], params: [{"filters", filters}])
  end

end
