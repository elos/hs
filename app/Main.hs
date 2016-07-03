module Main where

import Elos
import Elos.Autonomous

import SensorAgent

echoAgent :: Agent
echoAgent = listenForChange (putStrLn . show)

dummyAgent :: String -> Agent
dummyAgent output = listenForChange (putStrLn . const output)

agents = [echoAgent, sensorAgent "sensor_log.csv"]

main :: IO ()
main = elosRunApp $ agentApp agents
