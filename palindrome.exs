defmodule Palindrome do
  def input do
    IO.gets("Type in the word you want to check (case and space sensitive): ") |> String.trim()
  end
  def is_palindrome(string, n, i) do
    cond do
      String.at(string, i) == String.at(string, n) and n > i -> is_palindrome(string, n - 1, i + 1)
      String.at(string, i) == String.at(string, n) and n <= i -> "palindrome"
      String.at(string, i) != String.at(string, n) -> "not palindrome"
    end
  end
  def program do
    string = input()
    n = String.length(string) - 1
    is_palindrome(string, n, 0)
  end
end
Palindrome.program
