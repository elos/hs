module Main where

import Elos
import Elos.Autonomous

echoAgent :: Agent
echoAgent = listenForChange (putStrLn . show)

dummyAgent :: String -> Agent
dummyAgent output = listenForChange (putStrLn . const output)

agents = [echoAgent, dummyAgent "Hello!", echoAgent]

main :: IO ()
main = elosRunApp $ agentApp agents
