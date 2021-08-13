module Main where

import Prelude
import Data.Const (Const)
import Effect.Console (log)


import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML.Core as HC
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Halogen.HTML.Properties as HP



main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type Query = Const Void

data Action
  = ConsoleInput String

type State = { value :: String }

component :: forall m. H.Component Query Unit Void m
component = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval $ H.defaultEval
    { handleAction = handleAction }
  }
  where

  initialState :: State
  initialState = { value: "initial"}


  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.div_
    [ HH.textarea [HP.spellcheck false
                  , HP.rows 25
                  , HP.id "console-disp"
                  , HP.placeholder state.value]
    , HH.input[HP.spellcheck false
                  , HP.placeholder " >> "
                  , HP.id "console-inp"
                  , HE.onValueChange (\s -> (ConsoleInput s))] 
    ]



handleAction
  :: forall m
   . Action
  -> H.HalogenM State Action () Void m Unit
handleAction (ConsoleInput s) = do
    H.modify_ (\state -> state { value = "Echo: " <> s })

