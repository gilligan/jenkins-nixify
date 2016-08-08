{-# LANGUAGE OverloadedStrings #-}

module Parser where

import Data.Aeson
import Plugins

import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T

parseJSON :: B.ByteString -> Either String [JenkinsPlugin]
parseJSON = eitherDecode
