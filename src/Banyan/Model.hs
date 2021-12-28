{-# LANGUAGE TemplateHaskell #-}

module Banyan.Model where

import qualified Algebra.Graph.AdjacencyMap as AM
import Banyan.ID (NodeID, randomId)
import Banyan.Markdown (Meta, Pandoc)
import Control.Lens.Combinators (view)
import Control.Lens.Operators ((%~), (.~))
import Control.Lens.TH (makeLenses)
import Data.Default
import qualified Data.Map.Strict as Map

type Node = (Maybe Meta, Pandoc)

data Error = BadGraph Text | BadMarkdown Text
  deriving (Show, Eq, Ord)

data Model = Model
  { _modelNodes :: Map NodeID Node,
    _modelGraph :: AM.AdjacencyMap NodeID,
    _modelFiles :: Map FilePath FilePath,
    _modelNextID :: NodeID,
    _modelErrors :: Map FilePath Error
  }
  deriving (Show)

emptyModel :: MonadIO m => m Model
emptyModel = do
  rid <- randomId
  pure $
    Model
      { _modelNodes = Map.empty,
        _modelGraph = AM.empty,
        _modelFiles = Map.empty,
        _modelNextID = rid,
        _modelErrors = Map.empty
      }

makeLenses ''Model

modelDel :: NodeID -> Model -> Model
modelDel fp =
  modelNodes %~ Map.delete fp

modelAdd :: NodeID -> Node -> Model -> Model
modelAdd fp s =
  modelNodes %~ Map.insert fp s

modelLookup :: NodeID -> Model -> Maybe Node
modelLookup k =
  Map.lookup k . view modelNodes

modelAddFile :: FilePath -> FilePath -> Model -> Model
modelAddFile fp absPath =
  modelFiles %~ Map.insert fp absPath

modelDelFile :: FilePath -> Model -> Model
modelDelFile fp =
  modelFiles %~ Map.delete fp

modelResetNextID :: (MonadIO m, HasCallStack) => m (Model -> Model)
modelResetNextID = do
  rid <- liftIO randomId
  pure $ \model -> case modelLookup rid model of
    Just _ -> error $ "NanoID collision: " <> show rid
    Nothing -> model & modelNextID .~ rid

modelSetGraph :: AM.AdjacencyMap NodeID -> Model -> Model
modelSetGraph g =
  modelGraph .~ g

modelAddError :: FilePath -> Error -> Model -> Model
modelAddError fp e =
  modelErrors %~ Map.insert fp e

modelClearError :: FilePath -> Model -> Model
modelClearError fp =
  modelErrors %~ Map.delete fp