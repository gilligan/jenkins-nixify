{-# LANGUAGE OverloadedStrings #-}

module Resolver where

import Data.Maybe

import Data.ByteString.Builder (byteStringHex, toLazyByteString)

import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Base64 as Base64
import qualified Data.Set as S
import qualified Data.Text as T
import qualified Data.Text.Lazy as LT
import qualified Data.Text.Encoding as TE
import qualified Data.Text.Lazy.Encoding as LTE
import qualified Data.Map.Strict as M

import Parser
import Plugins

toNixSHA :: T.Text -> Either String T.Text
toNixSHA sha = (TE.decodeUtf8 . LB.toStrict . toLazyByteString . byteStringHex) <$> (Base64.decode . TE.encodeUtf8) sha

toNixExpression :: ResolvedPlugin -> PluginNixExpression
toNixExpression (ResolvedPlugin name deps sha version)  = case toNixSHA sha of
                                                              Left x -> error x
                                                              Right hash -> PluginNixExpression name hash version

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


resolve :: [T.Text] -> [JenkinsPlugin] -> S.Set PluginNixExpression
resolve pNames allPlugins = S.unions $ toSet <$> selectPlugins pNames (resolvePlugins allPlugins)
