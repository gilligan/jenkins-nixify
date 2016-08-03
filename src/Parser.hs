{-# LANGUAGE OverloadedStrings #-}

module Parser where

import Data.Aeson
import Plugins

import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T

parsePluginsJSON :: FilePath -> IO (Either String [JenkinsPlugin])
parsePluginsJSON path = eitherDecode <$> B.readFile path
