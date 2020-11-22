{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = defaultLayout $ do 
    toWidgetHead [hamlet|<script src=@{StaticR js_ola_js}>|]
    [whamlet|
            <h1>
                SISTEMA DE PRODUTOS
            <br>
            <img src=@{StaticR imgs_shop_svg}>
            <a href=@{ProdutoR}>
                CADASTRO DE PRODUTO
    |]
