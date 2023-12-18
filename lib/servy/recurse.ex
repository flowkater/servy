defmodule Servy.Recurse do
  def loopy([head | tail]) do
    IO.puts("Head: #{head} Tail: #{inspect(tail)}")
    loopy(tail)
  end

  def loopy([]), do: IO.puts("Done!")

  def sum([head | tail]), do: sum(tail, head)
  defp sum([head | tail], acc), do: sum(tail, acc + head)
  defp sum([], acc), do: acc

  # def triple([head | tail]), do: triple()

  def triple(list), do: triple(list, [])
  defp triple([head | tail], acc), do: triple(tail, [head * 3 | acc])
  defp triple([], acc), do: Enum.reverse(acc)
end
