app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br" }

import pf.Stdout
import pf.Task
import pf.Arg

help : Str
help =
  "usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate"

fizzBuzz : U32 -> Str
fizzBuzz = \x ->
    when x is
      _ if x % 15 == 0 -> "$(Num.toStr x): FizzBuzz"
      _ if x % 5 == 0 -> "$(Num.toStr x): Fizz"
      _ if x % 3 == 0 -> "$(Num.toStr x): Buzz"
      _ -> "$(Num.toStr x): $(Num.toStr x)"

main =
    args = Arg.list!
    if List.len args != 2 then
        Stdout.line! help
    else
        when (List.get args 1
            |> Result.try \n -> Str.toU32 n
            |> Result.try \n ->
                Ok (List.range { start: At 0, end: At n }
                    |> List.map fizzBuzz))
        is
            Err _ -> 
                Stdout.line! help
            Ok l ->
                Task.forEach l Stdout.line
