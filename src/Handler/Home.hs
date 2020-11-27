{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Home where

import Import

getAdminR :: Handler Html
getAdminR = do
    defaultLayout $ do
        [whamlet|
            <h1>
                BEM-VINDO, ADEMIR! 
        |]


getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    addStylesheet (StaticR css_estilo_css)
    toWidgetHead [hamlet|
        <script src=@{StaticR js_ola_js}>
    |]
    sess <- lookupSession "_ID"
    [whamlet|
            <div style="font-family: sans-serif">
                <h1>
                    SISTEMA DE PRODUTOS
                <br>
                <img src=@{StaticR imgs_shop_png} width=100% style="margin:0 auto;max-height:400px;" > <br>
                
                <ul style="list-style-type:none;" >
                    <li>
                        <a href=@{ProdutoR}>
                            CADASTRO DE PRODUTO
                    <li>                       
                        <a href=@{ListaR}>
                            LISTAGEM    
                    $maybe sessao <- sess
                        <li>                       
                            <a href=@{ListaR}>
                                LISTAGEM DE PRODUTOS
                        <li>              
                            <form action=@{LogoutR} method=post>
                                <input type="submit" value="Logout" style="border:none; padding:5px 20px; border-radius:5%;background-color:#f44;color:white">
                    $nothing
                        <li>
                            <a href=@{LoginR}>
                                Entrar


                        
                
    |]
