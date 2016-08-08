{-# LANGUAGE OverloadedStrings #-}

module Fetcher where

import qualified Data.ByteString.Lazy as B

fetchJSON :: FilePath -> IO B.ByteString
fetchJSON = B.readFile
