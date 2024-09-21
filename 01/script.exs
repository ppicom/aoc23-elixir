# Advent of code puzzle number one

defmodule Puzzle do
  def main do
    IO.puts(File.cwd!())

    with {:ok, content} <- File.read("01/input.txt"),
         {:ok, result} = process_input(content) do
      IO.puts("Result: #{inspect(result)}")
    else
      {:error, error} ->
        IO.puts(error)

      _ ->
        IO.puts("FFS bro")
    end
  end

  defp process_input(input) do
    result =
      String.split(input, "\n")
      |> Enum.map(fn line -> process_line(line) end)
      |> Enum.reduce(0, fn res, acc -> res + acc end)

    {:ok, result}
  end

  defp process_line(line) do
    graphs = String.graphemes(line)

    with n1 = find_forward(graphs), n2 = find_backwards(graphs) do
      String.to_integer(n1 <> n2)
    end
  end

  defp find_forward(graphs) do
    find(graphs, :forward)
  end

  defp find_backwards(graphs) do
    find(graphs, :backwards)
  end

  defp find(graphs, :forward) do
    Enum.reduce_while(graphs, 0, fn graph, _ ->
      if String.match?(graph, ~r/^\d$/) do
        {:halt, graph}
      else
        {:cont, graph}
      end
    end)
  end

  defp find(graphs, :backwards) do
    graphs |> Enum.reverse_slice(0, length(graphs)) |> find(:forward)
  end
end

Puzzle.main()
