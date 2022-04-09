defmodule Prime do
  def is_prime(n, i) when rem(n, i) != 0 and i != 1 do
    is_prime(n, i - 1)
  end
  def is_prime(n, i) when n == 1 or rem(n, i) == 0 and i != 1 do
    IO.puts("not prime")
  end
  def is_prime(n, i) when rem(n, i) == 0 and i == 1 do
    IO.puts("is prime")
  end
  def program do
    {number, _} = IO.gets("Enter the number (only positive integers will work): ") |> Integer.parse()
    cond do
      number >= 0 -> is_prime(number, number - 1)
      number < 0 -> :error
    end
  end
end
Prime.program
