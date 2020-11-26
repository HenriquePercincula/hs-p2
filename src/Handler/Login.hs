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

formLogin :: Form Usuario
formLogin = renderBootstrap3 BootstrapBasicForm $ Usuario
            <$> areq emailField "E-mail: " Nothing
            <*> areq passwordField "Senha: " Nothing
        

getLoginR :: Handler Html
getLoginR = do
    (formWidget, _) <- generateFormPost formUsuario
    mensagem <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        [whamlet|
            <div>
                $maybe msg <- mensagem
                    ^{msg}

            <form action=@{LoginR} method=post>
                ^{formWidget}
                <input type="submit" value="Entrar">
        |]        

postLoginR :: Handler Html
postLoginR = do
    ((result, _), _) <- runFormPost formLogin
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
