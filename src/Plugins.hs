{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Plugins where

import GHC.Generics
import Data.Aeson
import Data.Aeson.Types

import qualified Data.ByteString.Lazy as LB
import qualified Data.Text.Lazy.Encoding as LTE
import qualified Data.Text as T
import Text.Printf (printf)

dummySHA = "il8z91iDnqVMu78Ghj8q2swCpdk="
p1 = ResolvedPlugin "p1" [p4] dummySHA  "v1"
p2 = ResolvedPlugin "p2" [p3, p4] dummySHA  "v1"
p3 = ResolvedPlugin "p3" [] dummySHA  "v1"
p4 = ResolvedPlugin "p4" [] dummySHA  "v1"
pTop = ResolvedPlugin "top" [p1, p2, p3, p4] dummySHA "v2"



data PluginNixExpression = PluginNixExpression {
                           pluginName :: T.Text
                         , pluginSHA :: T.Text
                         , pluginVersion :: T.Text
                         } deriving (Eq, Ord)

instance Show PluginNixExpression where
        show (PluginNixExpression name sha version) = printf "\"%s\" = {\n  version = \"%s\";\n  sha1 = \"%s\";\n};\n" name version sha

data ResolvedPlugin = ResolvedPlugin {
                     prName :: T.Text
                   , prDeps :: [ResolvedPlugin]
                   , prSHA :: T.Text
                   , prVersion :: T.Text
                   } deriving (Eq, Ord, Show)

data JenkinsPluginRef = PluginRef {
                 name :: T.Text
               , optional :: Bool
               , version :: T.Text
               } deriving (Eq, Show, Generic)

instance FromJSON JenkinsPluginRef


data JenkinsDeveloperRef = JenkinsDeveloperRef {
                    _developerId :: Maybe T.Text
                  , _email :: Maybe T.Text
                  , _name :: Maybe T.Text
                  } deriving (Eq, Show, Generic)

instance FromJSON JenkinsDeveloperRef where
        parseJSON = genericParseJSON defaultOptions {
                                                    fieldLabelModifier = drop 1
                                                    }

data JenkinsPlugin = JenkinsPlugin {
              __buildDate :: T.Text
            , __dependencies :: [JenkinsPluginRef]
            , __developers :: [JenkinsDeveloperRef]
            , __excerpt :: T.Text
            , __gav :: T.Text
            , __labels :: [T.Text]
            , __name :: T.Text
            , __releaseTimestamp :: T.Text
            , __requiredCore :: T.Text
            , __scm :: Maybe T.Text
            , __sha1 :: T.Text
            , __title :: T.Text
            , __url :: T.Text
            , __version :: T.Text
            , __wiki :: T.Text
            } deriving (Eq, Show, Generic)


instance FromJSON JenkinsPlugin where
        parseJSON = genericParseJSON defaultOptions {
                                                    fieldLabelModifier = drop 2
                                                    }


