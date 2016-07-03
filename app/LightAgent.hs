{-# LANGUAGE RecordWildCards, OverloadedStrings #-}

module LightAgent where

import Elos
import Elos.Autonomous
import Elos.DB

import Data.Aeson
import Data.Aeson.Types
import qualified Data.HashMap.Strict as M

data LightEvent = LightEvent {
    time :: String,
    lightData :: LightEventData
}

instance FromJSON LightEvent where
    parseJSON = withObject "light event" $ \o ->
        LightEvent <$> o .: "time"
                   <*> o .: "data"

data LightEventData = LightEventData {
    light :: Float
}

instance FromJSON LightEventData where
    parseJSON = withObject "light event data" $ \o ->
        LightEventData <$> o .: "light"

lightAgent :: FilePath -> Agent
lightAgent fp = listenForChange $ writeLightValue fp

writeLightValue :: FilePath -> Change -> IO ()
writeLightValue fp ChangeUpdate{..} = do
    case parseMaybe parseJSON record of
        Just event -> appendFile fp $ showLightEvent event
        Nothing -> return ()

showLightEvent :: LightEvent -> String
showLightEvent event = concat [
                        time event, ",",
                        show . light . lightData $ event, "\n"
                       ]


