{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Tools where

import ClassyPrelude.Yesod
import Database.Persist.Quasi
import Import

formQt :: Form Int
formQt = renderDivs (areq intField "Quantidade: " (Just 1))
   