{-# LANGUAGE OverloadedStrings #-}

module Resolver where

import Data.Maybe
import qualified Data.Text as T
import qualified Data.Map.Strict as M

import Parser
import Plugins

getTopLevelPlugins :: [T.Text] -> [JenkinsPlugin] -> [JenkinsPlugin]
getTopLevelPlugins pNames = filter (isSelected pNames)
    where isSelected selected plugin = __name plugin `elem` selected

resolvePlugins :: [JenkinsPlugin] -> [ResolvedPlugin]
resolvePlugins ps = map snd (M.toList rpm)
  where
    pm  = M.fromList (map (\p -> (__name p, p)) ps)
    rpm = M.map (resolvePlugin rpm) pm

resolvePlugin :: M.Map T.Text ResolvedPlugin -> JenkinsPlugin -> ResolvedPlugin
resolvePlugin m plugin = ResolvedPlugin pluginName resolvedDeps "sha" "version"
    where
        pluginName = __name plugin
        deps = name <$> __dependencies plugin
        resolvedDeps = mapMaybe (`M.lookup` m) deps


resolve :: FilePath -> [T.Text] -> IO ()
resolve jsonFile pNames = do
        pluginData <- parsePluginsJSON jsonFile
        case pluginData of
            Left err -> putStrLn err
            Right allPlugins -> putStrLn $ show $ resolvePlugins $ getTopLevelPlugins pNames allPlugins
