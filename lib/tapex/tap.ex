defmodule Tapex.Tap do

  def format_plan(test_count), do: "1..#{test_count}"

  def format_header(), do: "TAP version 13"

  def format_line(ok, number, case, name, directive, message, colorize) do
    message_color =
      case {ok, directive} do
        {true, :todo} -> :cyan
        {false, :todo} -> :magenta
        {_, :skip} -> :yellow
        {true, _} -> :green
        {false, _} -> :red
      end
    format_line_status(ok, colorize)
    |> spacecat(format_line_number number, colorize )
    |> spacecat(format_line_message case, name, message_color, colorize)
    |> spacecat(format_line_directive directive, message, colorize)
  end

  defp format_line_status(true, colorize) do
    color_wrap("ok", :green, colorize)
  end
  defp format_line_status(false, colorize) do
    color_wrap("not ok", :red, colorize)
  end

  defp format_line_number(nil, colorize), do: nil
  defp format_line_number(number, colorize), do: to_string(number)

  defp format_line_message(nil, name, color, colorize) do
    color_wrap(name, color, colorize)
  end
  defp format_line_message(case, nil, color, colorize) do
    color_wrap(case, color, colorize)
  end
  defp format_line_message(case, name, color, colorize) do
    spacecat("#{case}:", color_wrap(name, color, colorize))
  end

  defp format_line_directive(nil, _, _), do: nil
  defp format_line_directive(_, false, _), do: nil
  defp format_line_directive(:skip, message, colorize) do
    "# " <> color_wrap("SKIP", :yellow, colorize) |> spacecat(message)
  end
  defp format_line_directive(:todo, message, colorize) do
    "# " <> color_wrap("TODO", :blue, colorize) |> spacecat(message)
  end

  defp spacecat(first_string, nil), do: first_string
  defp spacecat(first_string, ""), do: first_string
  defp spacecat(first_string, second_string) do
    first_string <> " " <> second_string
  end

  defp color_wrap(string, color, enabled) do
    [color | to_string(string)]
    |> IO.ANSI.format(enabled)
    |> IO.iodata_to_binary
  end
end