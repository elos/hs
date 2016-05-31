{-# LANGUAGE OverloadedStrings #-}

module Elos (
    elosRunApp
    ) where

import Elos.Autonomous
import qualified Elos.Config as Config
import qualified Elos.DB as DB
import Elos.Models

import Control.Concurrent (forkIO)
import Control.Monad (forever, void)
import Control.Monad.Trans (liftIO)
import qualified Data.ByteString.Char8 as B
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import qualified Network.WebSockets as WS

authRoute :: String -> String -> String
authRoute public private = "/record/changes/?public=" ++ public ++
                       "&private" ++ private

elosRunApp :: WS.ClientApp () -> IO ()
elosRunApp app = do
    config <- Config.defaultConfigPath >>= Config.loadConfig
    let host = Config.host config
        route = authRoute
            (Config.publicCredential config)
            (Config.privateCredential config)
    WS.runClientWith
        host
        80
        route
        WS.defaultConnectionOptions
        [("Origin", B.pack $ "http://" ++ host)]
        app

