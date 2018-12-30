defmodule ElixirDockerTest do
  use ExUnit.Case
  doctest ElixirDocker

  test "greets the world" do
    assert ElixirDocker.hello() == :world
  end
end
