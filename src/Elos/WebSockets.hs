module Elos.WebSockets where

import           Control.Monad (forever)
import           Control.Monad.Trans.Reader (ReaderT (ReaderT, runReaderT))
import qualified Network.WebSockets as WS
import           Pipes as P

type WebSocketsT = ReaderT WS.Connection

receiveData :: (MonadIO m, WS.WebSocketsData a) => WebSocketsT m a
receiveData = ReaderT $ liftIO . WS.receiveData

sourceWS :: (WS.WebSocketsData a, MonadIO m) => P.Producer a (WebSocketsT m) ()
sourceWS = forever $ lift receiveData >>= P.yield

