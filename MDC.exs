defmodule Mdc do
  def input do
    IO.puts("Greatest common divisor calculator. Only positive integer numbers are acceptable.")
    {x, _} = IO.gets("Type in the first number: ") |> Integer.parse()
    {y, _} = IO.gets("Type in the second number: ") |> Integer.parse()
    {x, y}
  end
  def max_divisor(x, y) when x == 0 or y == 0 do
    cond do
      x == 0 -> y
       y == 0 -> x
     end
  end
  def max_divisor(x, y) do
    remainder = rem(x, y)
    max_divisor(y, remainder)
  end
  def program do
    {a, b} = input()
    max_divisor(a, b)
  end
end
Mdc.program
