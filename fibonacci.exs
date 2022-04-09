defmodule Fibonacci do

  #getting the desired index in the fibonacci sequence by the user.
  defp number do
    {n, _} = IO.gets("Type in the n-th number of the fibonacci sequence you want: ") |> Integer.parse()
    n
  end

  #calculates the value of index n, decreasing the variable n by 1 at each call.
  defp fib(n, acc, prev) when n > 1 do
      next = acc + prev
      fib(n - 1, next, acc)
  end

  #When n hits 1, prints the result, since acc equals to the last calculated value of the sequence.
  #If the user typed n = 0, returns 0.
  defp fib(n, acc, _prev) when n <= 1 do
    cond do
      n == 1 -> IO.puts("The number is: #{acc}")
      n == 0 -> IO.puts("The number is: 0")
    end
  end

  #executes the program, so automatically gets the value of n typed by the user,
  #then sends it to the function fib/3, returning the result.
  def program do
    number() |> fib(1,0)
  end
end
Fibonacci.program
