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
    assert String.contains?(response, "🎉🎉🎉🎉🎉")
  end

  test "GET /about" do
    response = handle_request("GET", "/about")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "Clark's Wildthings Refuge")
    assert String.contains?(response, "🎉🎉🎉🎉🎉")
  end

  test "GET /pages/about" do
    response = handle_request("GET", "/pages/about")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "Clark's Wildthings Refuge")
    assert String.contains?(response, "🎉🎉🎉🎉🎉")
  end

  test "GET /bears/new" do
    response = handle_request("GET", "/bears/new")
    assert String.contains?(response, "200")
    assert String.contains?(response, "OK")
    assert String.contains?(response, "<form action=\"/bears\" method=\"POST\">")
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

  test "GET /wildlife" do
    response1 = handle_request("GET", "/wildlife")
    response2 = handle_request("GET", "/wildthings")
    assert response1 == response2
  end

  test "GET /bears?id=1" do
    response1 = handle_request("GET", "/bears?id=1")
    response2 = handle_request("GET", "/bears/1")
    assert response1 == response2
  end

  test "GET /bears?id=2" do
    response1 = handle_request("GET", "/bears?id=2")
    response2 = handle_request("GET", "/bears/2")
    assert response1 == response2
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
