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
    sensorData :: SensorEventData
}

instance FromJSON SensorEvent where
    parseJSON = withObject "sensor event" $ \o ->
        SensorEvent <$> o .: "time"
                    <*> o .: "data"

data SensorEventData = SensorEventData {
    light :: Float,
    sound :: Float
}

instance FromJSON SensorEventData where
    parseJSON = withObject "sensor event data" $ \o ->
        SensorEventData <$> o .: "light"
                        <*> o .: "sound"

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
                        show . light . sensorData $ event, ",",
                        show . sound . sensorData $ event, "\n"
                       ]


