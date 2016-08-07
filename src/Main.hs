{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text as T
import System.Environment

import Parser
import Plugins
import Resolver

help :: IO ()
help = putStrLn $
    unlines [ "Usage: jenkins-nixify resolve [jsonFile] [pluginA pluginB ...]"
            , "                      --help" 
            , ""
            , "\tresolve        resolve all plugins and their dependencies from jsonFile"
            , "\t--help         show this help screen"
            ]



main :: IO ()
main = do
    args <- getArgs
    run args where
        run ["--help"] = help
        run ["resolve", jsonFile, plugins] = resolve jsonFile ((T.words . T.pack) plugins)
        run _ = help

{-foo = Data.ByteString.Builder.byteStringHex  <$> Data.ByteString.Base64.decode "nrcD5sb9zwbDSyEPHAby3VG/MZ8="-}
{-Data.ByteString.Builder.toLazyByteString <$> foo-}
