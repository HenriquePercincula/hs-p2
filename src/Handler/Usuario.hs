{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Usuario where

import Import
import Text.Lucius
import Yesod.Persist.Core
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

formUsuario :: Form (Usuario, Text)
formUsuario = renderBootstrap3 BootstrapBasicForm $ (,)
    <$> (Usuario
            <$> areq emailField "E-mail: " Nothing
            <*> areq passwordField "Senha: " Nothing
        )
    <*> areq passwordField "Confirmacao: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (formWidget, _) <- generateFormPost formUsuario
    mensagem <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        [whamlet|
            <div>
                $maybe msg <- mensagem
                    ^{msg}

            <form action=@{UsuarioR} method=post>
                ^{formWidget}
                <input type="submit" value="Cadastrar" style="border:none; padding:5px 20px; border-radius:5%;background-color:#f44;color:white">
        |]        

postUsuarioR :: Handler Html
postUsuarioR = do
    ((result, _), _) <- runFormPost formUsuario
    case result of
        FormSuccess (Usuario email senha, conf) -> do
            if (senha == conf) then do
                runDB $ insert400 (Usuario email senha)
                redirect HomeR
            else do
                setMessage [shamlet|
                    <h1>
                        Senhas n conferem
                |]
                redirect UsuarioR
        _-> redirect HomeR
