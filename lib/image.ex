defmodule Docker.Image do
  import Docker.Request

  def list(params \\ []) do
    get("/images/json", [], params: params)
  end

  def build(params) do
    post("/build", "", [], params: params)
  end

  def build_prune(params \\ []) do
    post("/build/prune", "", [], params: params)
  end

  def create(params) do
    post("/build/create", "", [], params: params)
  end

  def inspect(image_name) do
    get("/images/#{image_name}/json")
  end

  def history(image_name) do
    get("/images/#{image_name}/history")
  end

  def push(image_name, tag) do
    post("/images/#{image_name}/push", "", [], params: [{"tag", tag}])
  end

  def tag(image_name, repo, tag) do
    post("/images/#{image_name}/tag", "", [], params: [{"repo", repo}, {"tag", tag}])
  end

  def remove(image_name, params) do
    delete("/images/#{image_name}", [], params: params)
  end

  def search(params) do
    get("/images/search", [], params: params)
  end

  def prune(filters) do
    post("/images/prune", "", [], params: [{"filters", filters}])
  end

  def commit(params, body) do
    post("/commit", body, [], params: params)
  end

end
