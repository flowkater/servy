defmodule Servy.Plugins do
  require Logger

  def emojify(%{status_code: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies
    %{conv | resp_body: body}
  end

  def emojify(conv), do: conv

  def track(%{status_code: 404, path: path} = conv) do
    IO.puts("Warning! No route found for #{path}")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  # def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
  #   %{conv | path: "/bears/#{id}"}
  # end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv), do: conv

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(conv) do
    Logger.info(inspect(conv))
    conv
  end
end
