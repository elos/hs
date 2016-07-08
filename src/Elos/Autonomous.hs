module Elos.Autonomous (
    Agent,
    agentApp,
    listenForChange,
    ) where

import Elos.DB (Change)

import Control.Monad (forever, void)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Reader (ReaderT (runReaderT), ask)

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import Data.Conduit
import qualified Data.Conduit.List as CL
import qualified Network.WebSockets as WS

type WebsocketsT = ReaderT WS.Connection
type Agent = Sink Change (WebsocketsT IO) ()

wsInOnce :: (MonadIO m, WS.WebSocketsData a) => Source (WebsocketsT m) a
wsInOnce = do
    conn <- lift ask
    x <- liftIO $ WS.receiveData conn
    yield x

wsIn :: (MonadIO m, WS.WebSocketsData a) => Source (WebsocketsT m) a
wsIn = wsInOnce >> wsIn

changes :: (MonadIO m) => Source (WebsocketsT m) Change
changes = wsIn =$= jsonConduit

jsonConduit :: (Monad m, FromJSON a) => Conduit B.ByteString m a
jsonConduit = CL.mapMaybe decode

agentApp :: [Agent] -> WS.ClientApp ()
agentApp agents conn = runReaderT (changes $$ agentsSink) conn
    where agentsSink = void $ sequenceSinks agents

listenForChange :: (Change -> IO ()) -> Agent
listenForChange f = awaitForever (liftIO . f)

