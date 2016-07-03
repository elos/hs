module Main where

import Elos
import Elos.Autonomous

import LightAgent

echoAgent :: Agent
echoAgent = listenForChange (putStrLn . show)

dummyAgent :: String -> Agent
dummyAgent output = listenForChange (putStrLn . const output)

--agents = [dummyAgent "I got an Event!", echoAgent]
agents = [echoAgent, lightAgent "light_log.csv"]

main :: IO ()
main = elosRunApp $ agentApp agents
