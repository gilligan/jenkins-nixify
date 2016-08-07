{-# LANGUAGE OverloadedStrings #-}

module Resolver where

import Data.Maybe
import qualified Data.Set as S
import qualified Data.Text as T
import qualified Data.Map.Strict as M

import Parser
import Plugins

toNixExpression :: ResolvedPlugin -> PluginNixExpression
toNixExpression (ResolvedPlugin name deps sha version)  = PluginNixExpression name sha version


toSet :: ResolvedPlugin -> S.Set PluginNixExpression
toSet = run S.empty
    where
        hasDeps = not . null . prDeps
        run packageSet plugin = if hasDeps plugin 
                                    then packageSet `S.union` S.unions ( run packageSet <$> prDeps plugin )
                                    else S.insert (toNixExpression plugin) packageSet


selectPlugins :: [T.Text] -> [ResolvedPlugin] -> [ResolvedPlugin]
selectPlugins pNames = filter (isSelected pNames)
    where isSelected selected plugin = prName plugin `elem` selected

resolvePlugins :: [JenkinsPlugin] -> [ResolvedPlugin]
resolvePlugins ps = map snd (M.toList rpm)
  where
    pm  = M.fromList (map (\p -> (__name p, p)) ps)
    rpm = M.map (resolvePlugin rpm) pm

resolvePlugin :: M.Map T.Text ResolvedPlugin -> JenkinsPlugin -> ResolvedPlugin
resolvePlugin m plugin = ResolvedPlugin pluginName resolvedDeps sha version
    where
        pluginName = __name plugin
        deps = name <$> __dependencies plugin
        resolvedDeps = mapMaybe (`M.lookup` m) deps
        sha = __sha1 plugin
        version = __version plugin


resolve :: FilePath -> [T.Text] -> IO ()
resolve jsonFile pNames = do
        pluginData <- parsePluginsJSON jsonFile
        case pluginData of
            Left err -> putStrLn err
            Right allPlugins -> putStrLn $ unlines (show  . toSet <$> selectPlugins pNames (resolvePlugins allPlugins))
