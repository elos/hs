{-# LANGUAGE OverloadedStrings #-}

module Elos.Config where

import System.Directory

import Data.Aeson
import qualified Data.ByteString.Lazy as B

data Config = Config {
    host :: String,
    publicCredential :: String,
    privateCredential :: String,
    userId :: String
} deriving (Show)

instance FromJSON Config where
    parseJSON = withObject "config" $ \o ->
        Config <$> o .: "Host"
               <*> o .: "PublicCredential"
               <*> o .: "PrivateCredential"
               <*> o .: "UserID"

defaultConfigPath :: IO FilePath
defaultConfigPath = fmap (++ "/elosconfig.json") getHomeDirectory

loadConfig :: FilePath -> IO Config
loadConfig fp = do
    configFile <- B.readFile fp
    let (Just config) = decode configFile
    return config

