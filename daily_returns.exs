Mix.install([{:nimble_csv, "~> 1.1"}])
alias NimbleCSV.RFC4180, as: CSV

defmodule Main do
  def calc(price, prev_price) do # defines return formula
    price / prev_price - 1
  end


  defmodule Part3 do
    def read do                             #reads from csv
      {_, file} = File.read("results.csv")
      String.replace(file, "/", "-") |>
      CSV.parse_string |> Enum.map(fn [date, price, daily_return] ->
        [Date.from_iso8601!(date), Main.formatter(price), daily_return]
      end)
    end
    def parsing(file, index, desired_date, file_length, diff) when index < file_length do  #goes trough list, checking if the date exists, if not,
      [date, price, _] = Enum.at(file, index)                                              #chooses the next available date
      member = date == desired_date
      parse_check(member, price, file, index, desired_date, file_length, diff)
    end
    def parsing(file, index, desired_date, file_length, _diff) when index == file_length do
      find_date(desired_date, 1, file, file_length)
    end
    def parse_check(member, price, file, index, desired_date, file_length, diff) do
      if member do
        price
      else
        parsing(file, index + 1, desired_date, file_length, diff)
      end
    end
    def find_date(date, diff, file, file_length) do
      desired_date = Date.add(date, diff)
      parsing(file, 0, desired_date, file_length, diff)
    end
    def run do
      list = read()
      list_length = length(list)
      dump(list, 0, list_length) |> write()
    end
    def parse_to_dump(list, index, length) do
      [date, price, _] = Enum.at(list, index)
      prev_price = find_date(date, -7, list, length)
      Main.calc(price, prev_price)
    end

    def dump(list, index, length) do
      cond do
        index < length - 7 ->
        new = Enum.at(list, index) ++ [parse_to_dump(list, index, length)]
        new_list = [new] ++ dump(list, index + 1, length)
        index == length - 7 -> [Enum.at(list, index) ++ ["no weekly return, not enough data"]]
      end
    end
    def write(dumped_list) do
      list_with_header = [["Date,Price,Daily_Return,7_day_return"]] ++ dumped_list
      csv = CSV.dump_to_iodata(list_with_header)
      File.write("results.csv", csv)
    end

  end


  defmodule Part2 do
    def read_file do
      {_, file} = File.read("s&p500.csv")
      String.replace(file, "/", "-") |>
       CSV.parse_string |> Enum.map(fn [date, price] ->
        [date: date, price: Main.formatter(price)]
      end)
    end

    def read_dates(file, index) do
    length = length(file)
    start_date = IO.gets("Type in the start date (yy-mm-dd): ") |> String.trim()
    start_price = parsing(file, index, start_date, length)
    end_date = IO.gets("Type in the end date (yy-mm-dd): ") |> String.trim()
    end_price = parsing(file, index, end_date, length)
    [start_price, end_price]
    end

    def parsing(file, index, desired_date, file_length) when index < file_length do
      [{_, date},{_, price}] = Enum.at(file, index)
      member = date == desired_date
      parse_check(member, price, file, index, desired_date, file_length)
    end

    def parsing(_file, index, _desired_date, length) when index == length do
      {answer, _} = IO.gets("date not found, 1 to try again, 0 to abort: ") |> Integer.parse
      cond  do
        answer == 1 ->
          run()
          System.halt()
        answer == 0 ->
          System.halt()
      end

    end

    def parse_check(member, price, file, index, desired_date, file_length) do
      if member do
        price
      else
        parsing(file, index + 1, desired_date, file_length)
      end
    end

    def run do
      [start_price, end_price] = read_file() |> read_dates(0)
      acc_return = Main.calc(end_price, start_price)
      IO.puts("The accumulated return for the given period is: #{acc_return}")
    end
  end

  defmodule Return do
    def run do
      list = read("s&p500.csv")
      results = parser(list, 0, length(list))
      dump(list, results, 0, length(list)) |> write()
    end

    def read(filename) do
      {_, file} = File.read(filename)
      list = CSV.parse_string file
      Enum.map(list, fn [date, price] ->
        [date, Main.formatter(price)]
      end)
    end

    def parser(lista, index, lenght) when index <= lenght - 2 do
      [_, price] = Enum.at(lista, index)
      [_, prev_price] = Enum.at(lista, index + 1)
      list = [Main.calc(price, prev_price)]
      list ++ parser(lista, index + 1, lenght)
    end

    def parser(_lista, index, lenght) when index == lenght - 1 do
      "no daily return, because there's no price for any previous date"
    end

    def dump(list, results, index, length) do
      cond do
        index <= length - 2 ->
        new = Enum.at(list, index) ++ [Enum.at(results, index)]
        _new_list = [new] ++ dump(list, results, index + 1, length)
        index == length - 1 -> [Enum.at(list, index) ++ ["no daily return, because theres no price for any previous date"]]
      end
    end

    def write(dumped_list) do
      list_with_header = [["Date,Price,Daily_Return"]] ++ dumped_list
      csv = CSV.dump_to_iodata(list_with_header)
      File.write("results.csv", csv)
    end
  end

  def formatter(price) do
    {newprice, _} = Float.parse(price)
    newprice
  end
  def run do
    {answer, _} = IO.gets("Type 1 to write a .csv with results, 2 to calculate return for a given period: ") |> Integer.parse()
    cond do
      answer == 1 -> Main.Return.run()
        Main.Part3.run()
      answer == 2 -> Main.Part2.run()
      true -> :error
    end
  end
end
Main.run()
