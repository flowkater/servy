defmodule Servy.Handler do
  import Servy.Plugins, only: [emojify: 1, track: 1, rewrite_path: 1, log: 1]
  import Servy.Parser, only: [parse: 1]

  @moduledoc """
  Handles HTTP requests
  """

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms an HTTP request into an HTTP response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> emojify
    |> track
    |> format_response
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status_code: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status_code: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status_code: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status_code: 403, resp_body: "Deleting bears is forbidden!"}
  end

  def route(%{method: _method, path: path} = conv) do
    %{conv | status_code: 404, resp_body: "No #{path} here!"}
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status_code: 200, resp_body: content}
  end

  def handle_file({:error, :eoent}, conv) do
    %{conv | status_code: 404, resp_body: "File Not Found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status_code: 500, resp_body: "File error: #{reason}"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status_code} #{status_reason(conv.status_code)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts(response)

# request = """
# GET /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts(response)

# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts(response)

# expected_response = """
# HTTP/1.1 200 OK
# Content-Type: text/html
# Content-Length: 20

# Bears, Lions, Tigers
# """

# elixir lib/servy.ex
