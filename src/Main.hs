{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans.Either (runEitherT, hoistEither)
import qualified Data.Text as T
import System.Environment

import Parser 
import Plugins
import Resolver
import Fetcher
import Printer

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
        run ["resolve", jsonFile, plugins] = do
            jsonData <- fetchJSON jsonFile
            pluginData <- runEitherT $ hoistEither $ parseJSON jsonData
            case pluginData of
                Left err -> error err
                Right allPlugins -> (putStr . T.unpack) $ printPlugins pluginNames $ resolve pluginNames allPlugins
                where
                    pluginNames = (T.words . T.pack) plugins
        run _ = help
