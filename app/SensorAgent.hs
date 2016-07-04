{-# LANGUAGE RecordWildCards, OverloadedStrings #-}

module SensorAgent where

import Elos
import Elos.Autonomous
import Elos.DB

import Data.Aeson
import Data.Aeson.Types
import qualified Data.HashMap.Strict as M

data SensorEvent = SensorEvent {
    time :: String,
    light :: Float,
    sound :: Float
}

instance FromJSON SensorEvent where
    parseJSON = withObject "sensor event" $ \o -> do
        time <- o .: "time"

        sensorData <- o .: "data"

        light <- sensorData .: "light"
        sound <- sensorData .: "sound"

        return SensorEvent{..}

sensorAgent :: FilePath -> Agent
sensorAgent fp = listenForChange $ writeSensorValue fp

writeSensorValue :: FilePath -> Change -> IO ()
writeSensorValue fp ChangeUpdate{..} =
    case parseMaybe parseJSON record of
        Just event -> appendFile fp $ showSensorEvent event
        Nothing -> return ()

showSensorEvent :: SensorEvent -> String
showSensorEvent event = concat [
                            time event, ",",
                            show . light $ event, ",",
                            show . sound $ event, "\n"
                        ]


