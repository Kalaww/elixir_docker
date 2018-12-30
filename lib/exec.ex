defmodule Docker.Exec do
  import Docker.Request

  def create(container_id, config) do
    with {:ok, %{"Id" => id}} <- post("/containers/#{container_id}/exec", config)
    do
      {:ok, id}
    end
  end

  def start(exec_id, body) do
    post("/exec/#{exec_id}/start", body)
  end

  def resize(exec_id, width, height) do
    post("/exec/#{exec_id}/resize", "",[], params: [{"w", width}, {"h", height}])
  end

  def inspect(exec_id) do
    post("/exec/#{exec_id}/json")
  end

end
