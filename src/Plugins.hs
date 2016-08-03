{-# LANGUAGE DeriveGeneric #-}

module Plugins where

import GHC.Generics
import Data.Aeson
import Data.Aeson.Types

import qualified Data.Text as T

data ResolvedPlugin = ResolvedPlugin {
                     prName :: T.Text
                   , prDeps :: [ResolvedPlugin]
                   , prSHA :: T.Text
                   , prVersion :: T.Text
                   } deriving (Eq, Show)

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


