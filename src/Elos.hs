{-# LANGUAGE OverloadedStrings, RecordWildCards #-}

module Elos (
    elosRunApp
    ) where

import Elos.Config
import qualified Data.ByteString.Char8 as B
import qualified Network.WebSockets as WS

authRoute :: String -> String -> String
authRoute public private = concat [
                            "/record/changes/?public=", public,
                            "&private=", private
                           ]

elosRunApp :: WS.ClientApp a -> IO a
elosRunApp app = do
    Config{..} <- defaultConfigPath >>= loadConfig
    let route = authRoute publicCredential privateCredential
    WS.runClientWith
        host
        80
        route
        WS.defaultConnectionOptions
        [("Origin", B.pack $ "http://" ++ host)]
        app

