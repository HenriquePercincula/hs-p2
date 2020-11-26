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
    toWidgetHead [hamlet|
        <script src=@{StaticR js_ola_js}>
    |]
    sess <- lookupSession "_ID"
    [whamlet|
            <h1>
                SISTEMA DE PRODUTOS
            <br>
            <img src=@{StaticR imgs_shop_svg} width=100% style="margin:0 auto;max-height:400px;" > <br>
            
            <ul>
                <li>
                    <a href=@{ProdutoR}>
                        CADASTRO DE PRODUTO    
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
