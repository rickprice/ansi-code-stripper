{-# LANGUAGE Unsafe #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_HADDOCK show-extensions #-}

{- |
Module      : Main
Description : Strip ANSI and other things from "script" output
Copyright   : (c) 2024 Frederick Price
License     : BSD-3-Clause
Maintainer  : fprice@pricemail.ca
Stability   : experimental
Portability : POSIX

Command line utility and library to convert Google Takeout Location data to KML format
-}
module Main (main) where

import Relude

-- import Data.Void
import Text.Megaparsec as MT
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer
import Replace.Megaparsec

import Prelude (interact)

csi :: ParsecT Void String Identity String
csi = string "\x1b["
-- csi = pure <$> single '\x1b' <*> single '['

cuu :: ParsecT Void String Identity String
cuu = csi <> MT.some digitChar <> chunk "A"
-- cuu = chunk "\x1b[" <> MT.many digitChar <> chunk "A" 


ftest :: ParsecT Void String Identity String
-- ftest = pure  <$> csi <*> MT.some digitChar <*> oneOf "ABCDEFG"
-- ftest = pure  <$> (MT.some digitChar) <*> oneOf "ABCDEFG"::String
-- ftest = pure  <$> oneOf "ABCDEFG"::String
-- ftest = pure  <$> (MT.some digitChar) 
ftest = csi <> (MT.some digitChar) <*> oneOf "ABCDEFG"::String


main :: IO ()
-- main = interact $ streamEdit (decimal :: Parsec Void String Int) (show . (*2))
main = interact $ streamEdit ftest (const "") 
-- main = do
--     -- Get the configuration data from command line parameters
--     configuration <- getConfiguration
--
--     -- Get the location records from the Google Takout file
--     locationList <- GL.getLocationRecordsFromFilePath (inputFilename configuration)
--
--     -- Filter records by date if required
--     now <- getCurrentTime
--     let listToOutput = case filterOlderThanDays configuration of
--             Nothing -> locationList
--             Just x -> GL.filterOlderThan filterDate locationList
--               where
--                 filterDate = GL.addDaysUTCTime ((-1) * x) now
--
--     -- Output as KML
--     case outputFilename configuration of
--         Nothing -> BIO.hPutStr stdout (B.toLazyText (KML.toKML listToOutput))
--         Just x -> writeFileLText x (B.toLazyText (KML.toKML listToOutput))
