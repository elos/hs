{-# LANGUAGE OverloadedStrings #-}

module Elos where

import Elos.Autonomous
import Elos.DB
import Elos.Models

import Control.Concurrent (forkIO)
import Control.Monad (forever, void)
import Control.Monad.Trans (liftIO)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import qualified Network.WebSockets as WS


main :: IO ()
main = WS.runClientWith
        "elos.pw"
        80
        "/record/changes/?public=public&private=private"
        WS.defaultConnectionOptions
        [("Origin", "http://elos.pw")]
        app

