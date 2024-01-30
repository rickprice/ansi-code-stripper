#!/usr/bin/env stack
{- stack
  script
  --resolver lts-22
  --package megaparsec
  --package replace-megaparsec
-}
-- https://docs.haskellstack.org/en/stable/GUIDE/#script-interpreter

import Data.Void
import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer
import Replace.Megaparsec

main = interact $ streamEdit (decimal :: Parsec Void String Int) (show . (*2))
