defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "GET /bears" do
    response = handle_request("GET", "/bears")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "Teddy, Smokey, Paddington")
  end

  test "GET /wildthings" do
    response = handle_request("GET", "/wildthings")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "Bears, Lions, Tigers")
  end

  test "GET /bigfoot" do
    response = handle_request("GET", "/bigfoot")
    assert String.contains?(response, "404")
    assert String.contains?(response, "Not Found")
    assert String.contains?(response, "No /bigfoot here!")
  end

  test "GET /bears/1" do
    response = handle_request("GET", "/bears/1")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "Bear 1")
  end

  test "DELETE /bears/1" do
    response = handle_request("DELETE", "/bears/1")
    assert String.contains?(response, "403")
    assert String.contains?(response, "Forbidden")
    assert String.contains?(response, "Deleting bears is forbidden!")
  end

  defp handle_request(method, path) do
    """
    #{method} #{path} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> log_response()
  end

  defp log_response(response) do
    IO.puts(response)
    response
  end
end
