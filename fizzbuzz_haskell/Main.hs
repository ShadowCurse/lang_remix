import Data.List
import Numeric.Natural
import System.Environment
import System.Exit
import Text.Printf
import Text.Read (readMaybe)

printHelpAndExit :: String
printHelpAndExit = do
  "usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate"

parseInteger :: String -> Maybe Natural
parseInteger [] = Nothing
parseInteger s = readMaybe . head . words $ s

fizzbuzz :: Natural -> String
fizzbuzz n = intercalate "\n" [checkNumber x | x <- [1 .. n]]

checkNumber :: Natural -> String
checkNumber x
  | x `mod` 15 == 0 = printf "%d: %s" x "Fizzbuzz"
  | x `mod` 5 == 0 = printf "%d: %s" x "Fizz"
  | x `mod` 3 == 0 = printf "%d: %s" x "Buzz"
  | otherwise = printf "%d: %d" x x

main :: IO ()
main = do
  args <- getArgs
  if length args /= 1
    then do
      putStrLn printHelpAndExit
      exitSuccess
    else putStrLn $ maybe printHelpAndExit fizzbuzz (parseInteger $ head args)
