defmodule Puzzle do
  def main do
    with {:ok, content} <- File.read("02/input.txt"),
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
    {:ok,
     String.split(input, "\n")
     |> Enum.map(&parse_game(&1))
     |> Enum.map(&find_power(&1))
     |> Enum.reduce(0, fn elem, acc -> Map.get(elem, "power") + acc end)}
  end

  # A game looks like:
  # Game 1: 14 green, 8 blue, 9 red; 5 blue, 4 green, 2 red; 4 red, 4 blue, 4 green; 1 blue, 3 green, 2 red; 10 red, 3 blue, 15 green; 2 red, 6 green, 3 blue
  defp parse_game(line) do
    [game | plays] = String.split(line, ": ")
    [_, id] = String.split(game, " ")

    plays
    |> Enum.flat_map(fn plays -> String.split(plays, "; ") end)
    |> Enum.flat_map(fn hands -> String.split(hands, ", ") end)
    |> Enum.map(fn hand ->
      [count, color] = String.split(hand, " ")
      {String.to_integer(count), color}
    end)
    |> Enum.reduce(%{}, fn {count, color}, acc ->
      Map.update(acc, color, count, &max(count, &1))
    end)
  end

  defp find_power(game) do
    pow =
      Map.values(game)
      |> Enum.reduce(1, &(&1 * &2))

    Map.put(game, "power", pow)
  end

  @canonical_game %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  defp is_possible(game) do
    Map.keys(@canonical_game)
    |> Enum.reduce_while(true, fn color, _acc ->
      with cubes_in_game <- Map.get(game, color),
           cubes_in_canonical_game = Map.get(@canonical_game, color) do
        if cubes_in_game > cubes_in_canonical_game do
          IO.puts(
            "Game hade more #{color} cubes (#{cubes_in_game}) than canonical (#{cubes_in_canonical_game})"
          )

          {:halt, false}
        else
          {:cont, true}
        end
      end
    end)
  end
end

Puzzle.main()
