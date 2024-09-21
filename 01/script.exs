# Advent of code puzzle number one

defmodule Puzzle do
  def main do
    # IO.puts(File.cwd!()

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
    with n1 = find(line, :at_prefix), n2 = find(line, :at_suffix) do
      IO.puts("In line '#{line}' I found '#{n1}' and '#{n2}', making #{n1 <> n2}'")
      String.to_integer(n1 <> n2)
    end
  end

  @number_to_value %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  defp find(line, where) do
    case with_number(line, where) do
      {:ok, number} ->
        number

      _ ->
        case with_number_name(line, where) do
          {:ok, number} ->
            number

          _ ->
            if where == :at_prefix do
              find(String.slice(line, 1, String.length(line)), where)
            else
              find(String.slice(line, 0, String.length(line) - 1), where)
            end
        end
    end
  end

  defp with_number(line, :at_prefix) do
    if String.match?(String.at(line, 0), ~r/^\d$/) do
      {:ok, String.at(line, 0)}
    else
      {:error, "not a number"}
    end
  end

  defp with_number(line, :at_suffix) do
    # IO.puts("with_number() called with '#{line}' and :at_suffix"

    if String.match?(String.at(line, String.length(line) - 1), ~r/^\d$/) do
      {:ok, String.at(line, String.length(line) - 1)}
    else
      {:error, "not a number"}
    end
  end

  defp with_number_name(line, :at_prefix) do
    number_name =
      Map.keys(@number_to_value)
      |> Enum.reduce_while("", fn number_name, _ ->
        if String.starts_with?(line, number_name) do
          {:halt, number_name}
        else
          {:cont, ""}
        end
      end)

    if number_name == "" do
      {:error, "#{line} doesn't start with the name of a number"}
    else
      {:ok, Map.get(@number_to_value, number_name)}
    end
  end

  defp with_number_name(line, :at_suffix) do
    # IO.puts("with_number_name() called with #{line} and :at_suffix"

    number_name =
      Map.keys(@number_to_value)
      |> Enum.reduce_while("", fn number_name, _ ->
        if String.ends_with?(line, number_name) do
          {:halt, number_name}
        else
          {:cont, ""}
        end
      end)

    if number_name == "" do
      {:error, "#{line} doesn't end with the name of a number"}
    else
      {:ok, Map.get(@number_to_value, number_name)}
    end
  end
end

Puzzle.main()
