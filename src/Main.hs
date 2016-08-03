{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text as T
import System.Environment

import Parser
import Plugins
import Resolver

{-selectedPlugins :: [Text]-}
{-selectedPlugins = ["workflow-aggregator", "credentials-binding", "git", "htmlpublisher", "job-dsl", "timestamper", "git-parameter", "matrix-auth", "github", "build-name-setter", "groovy", "ansicolor"]-}

{-getPlugins :: [Text] -> [Plugin] -> [Plugin]-}
{-getPlugins selectedPlugins allPlugins = undefined-}

{-parsePluginsJSON :: FilePath -> IO (Either String [Plugin])-}
{-parsePluginsJSON path = eitherDecode <$> getJSON path-}

{-isSelectedPlugin :: [Text] -> Plugin -> Bool-}
{-isSelectedPlugin selectedPlugins p = __name p `elem` selectedPlugins-}

{-getTopLevelPlugins :: [Text] -> [Plugin] -> [Plugin]-}
{-getTopLevelPlugins selectedPlugins = filter (isSelectedPlugin selectedPlugins)-}

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


{-main :: IO ()-}
{-main = do-}
        {-p <- parsePluginsJSON "jenkins.json"-}
        {-case p of-}
            {-Left err -> putStr err-}
            {-Right allPlugins-> putStr $ show $ getTopLevelPlugins selectedPlugins allPlugins-}
            {-Right allPlugins-> putStr $ show $ resolvePlugins $ getTopLevelPlugins selectedPlugins allPlugins-}
