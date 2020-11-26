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
    addStylesheet (StaticR css_estilo_css)
    toWidgetHead [hamlet|<script src=@{StaticR js_ola_js}>|]
    [whamlet|
            <h1>
                SISTEMA DE PRODUTOS
            <br>
            <img src=@{StaticR imgs_shop_svg}>
            
            <ul>
                <li>
                    <a href=@{ProdutoR}>
                        CADASTRO DE PRODUTO
                <li>
                    <a href=@{ListaR}>
                        LISTAGEM DE PRODUTO
                
    |]
