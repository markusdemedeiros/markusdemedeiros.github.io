module Main where

import Prelude
import Data.Const (Const)
import Effect.Console (log)
import Effect.Class
import Data.Unit (unit)

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML.Core as HC
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Halogen.HTML.Properties as HP
import Web.UIEvent.KeyboardEvent (key, code)
import Halogen.Query.Input as HQ



main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type Query = Const Void

data Action
  = Enter
  | NonEnter

type State = { console :: String } 

component :: forall m. (MonadEffect m) => H.Component Query Unit Void m
component = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval $ H.defaultEval
    { handleAction = handleAction }
  }
  where

  initialState :: State
  initialState = { console: "Type something below!" }


  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.div_
    [ HH.textarea [HP.spellcheck false
                  , HP.rows 25
                  , HP.id "console-disp"
                  , HP.placeholder state.console
                  , HP.readOnly true
                  ]
    , HH.input[HP.spellcheck false
                  , HP.placeholder " >> "
                  , HP.id "console-inp"
                  , HE.onKeyDown $ 
                      (\ev -> if (code ev == "Enter") 
                              then Enter
                              else NonEnter)]
                  -- , HE.onValueChange (\s -> (ConsoleInput s))] 
    ]



handleAction
  :: forall m
   . (MonadEffect m) => Action
  -> H.HalogenM State Action () Void m Unit
handleAction (NonEnter) = pure unit
handleAction (Enter) = do
    s <- liftEffect $ clearById "console-inp"
    liftEffect $ log s
    H.modify_ $ handleCommand s
    new_st <- H.get
    liftEffect $ setById "console-disp" (new_st.console)
    pure unit



handleCommand :: String -> State -> State 
handleCommand s  = (\state -> state { console = "I recieved the command: " <> s})



foreign import clearById:: String -> Effect String 
foreign import setById:: String -> String -> Effect Unit

