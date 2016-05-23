module Elos.Autonomous where

import Control.Monad (forever)
import Control.Monad.IO.Class (liftIO)
import Data.Conduit
import Elos.DB

import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Reader (ReaderT (runReaderT), ask)

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import qualified Data.Conduit.List as CL
import qualified Network.WebSockets as WS

type WebsocketsT = ReaderT WS.Connection
type Agent = Sink Change (WebsocketsT IO) ()

wsSource :: (MonadIO m, WS.WebSocketsData a) => Source (WebsocketsT m) a
wsSource = do
    conn <- lift ask
    x <- liftIO $ WS.receiveData conn
    yield x

changes = wsSource $= changeConduit

changeConduit :: (Monad m) => Conduit B.ByteString m Change
changeConduit = CL.mapMaybe decode

agents = sequenceSinks [echoAgent, dummyAgent, echoAgent]

app :: WS.ClientApp ()
app conn = forever $ runReaderT (changes $$ agents) conn

echoAgent :: Agent
echoAgent = awaitForever (liftIO . putStrLn . show)

dummyAgent = awaitForever (liftIO . putStrLn . const "YOOO")

