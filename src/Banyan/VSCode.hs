{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeApplications #-}

-- | Integration with VSCode extension
module Banyan.VSCode
  ( VSCodeAction (..),
    renderVSCodeAction,
  )
where

import Banyan.ID
import Text.Blaze.Html5 ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.URI (URI)
import qualified Text.URI as URI
import qualified Text.URI.QQ as URIQQ

data VSCodeAction
  = NewNode NodeID (Maybe NodeID)
  | EditNode NodeID
  deriving (Eq, Show)

-- | Base URI to invoke the vscode-extension for banyan
extUri :: URI
extUri = [URIQQ.uri|vscode://srid.banyan/new/|]

mkUri :: VSCodeAction -> URI
mkUri (NewNode nid mParent) =
  extUri
    { URI.uriPath =
        (False,) <$> do
          nid' <- URI.mkPathPiece @Maybe (show nid)
          pure $ [URIQQ.pathPiece|new|] :| [nid'],
      URI.uriQuery =
        maybeToList $
          mParent >>= \parent ->
            URI.QueryParam
              <$> URI.mkQueryKey "parent" <*> URI.mkQueryValue (show parent)
    }
mkUri (EditNode nid) =
  extUri
    { URI.uriPath =
        (False,) <$> do
          nid' <- URI.mkPathPiece @Maybe (show nid)
          pure $ [URIQQ.pathPiece|edit|] :| [nid']
    }

renderVSCodeAction :: VSCodeAction -> H.Html
renderVSCodeAction action = do
  let uri = mkUri action
  H.a
    ! A.class_ "bg-blue-400 text-sm text-white p-1 my-2"
    ! A.href (H.toValue $ URI.render uri)
    $ actionTitle
  where
    actionTitle = case action of
      NewNode _ _ -> "New Node (under here)"
      EditNode _ -> "Edit Node"