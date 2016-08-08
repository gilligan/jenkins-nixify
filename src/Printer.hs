{-# LANGUAGE OverloadedStrings #-}

module Printer where

import Data.Monoid ((<>))
import qualified Data.Set as S
import qualified Data.Text as T
import Text.Printf (printf)

import Plugins

headerText :: T.Text
headerText = "# Generated automatically with jenkins-nixify\n# Top-Level plugins: "

printPlugins :: [T.Text] -> S.Set PluginNixExpression -> T.Text
printPlugins plugins expressions = header <> "{\n" <> showExpressions expressions <> "}\n"
    where
        header = headerText <> T.unwords plugins <> "\n"
        showExpressions =  T.pack . concatMap (indent . show)
        indent = unlines . map (" " ++) . lines

