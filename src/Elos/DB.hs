{-# LANGUAGE OverloadedStrings #-}

module Elos.DB where

import Data.Aeson.Types
import Data.ByteString as B
import Data.Text as T

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

makeChange 1 = Just ChangeUpdate
makeChange 2 = Just ChangeDelete
makeChange _ = Nothing

instance FromJSON Change where
    parseJSON = withObject "change" $ \o -> do
        changeKind <- o .: "change_kind" :: Parser Int
        case makeChange changeKind of
            Nothing -> fail "Invalid change_kind"
            Just cons -> cons <$> o .: "record_kind"
                              <*> o .: "record"

