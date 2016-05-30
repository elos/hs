{-# LANGUAGE OverloadedStrings #-}

module Elos.DB where

import Data.Aeson.Types
import Control.Lens
import Data.ByteString as B
import Data.ByteString.Lazy as BL
import Data.Text as T
import Network.WebSockets

data DB = DB {
    host :: String,
    username :: B.ByteString,
    password :: B.ByteString
}

data Query a = Query {
    kind :: T.Text,
    limit :: Int,
    skip :: Int,
    attrs :: a
}

data Change = ChangeUpdate { recordKind :: String, record :: Object }
            | ChangeDelete { recordKind :: String, record :: Object }
            deriving (Show)

makeChange 1 = ChangeUpdate
makeChange 2 = ChangeDelete

instance FromJSON Change where
    parseJSON (Object o) = do
        changeKind <- o .: "change_kind" :: Parser Int
        let cons = makeChange changeKind
        recordKind <- o .: "record_kind"
        record <- o .: "record"
        return $ cons recordKind record

