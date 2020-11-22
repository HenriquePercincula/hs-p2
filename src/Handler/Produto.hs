{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Produto where

import Import
import Text.Lucius
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

-- fmap functor f => (a -> b) -> f a -> f b
-- (<*>) :: Applicative f => f (a -> b) -> f a -> f b
-- renderDivs

formProduto :: Form Produto
formProduto = renderBootstrap3 BootstrapBasicForm $ Produto -- ou renderDivs
    <$> areq textField (FieldSettings  "Nome: " 
                                                Nothing
                                                (Just "h21")
                                                Nothing
                                                [("class","minhaClasse")]) Nothing 
    <*> areq doubleField "Preco: " Nothing
 
getProdutoR :: Handler Html
getProdutoR = do 
    -- formWidget TERA TODAS AS TAGS DE FORMULARIO
    (formWidget, _) <- generateFormPost formProduto
    defaultLayout $ do
        -- pasta: static/css/bootstrap.css
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(luciusFile "templates/descr.lucius")
        [whamlet|
            <form action=@{ProdutoR} method=post>
                ^{formWidget}
                <input type="submit" value="OK">
        |]

postProdutoR :: Handler Html
postProdutoR = do
    ((result, _), _) <- runFormPost formProduto
    case result of
        FormSuccess produto -> do
            pid <- runDB $ insert produto
            redirect (DescR pid)
        _-> redirect HomeR

getDescR :: ProdutoId -> Handler Html
getDescR pid = do
    produto <- runDB $ get404 pid
    defaultLayout $ do
        $(whamletFile "templates/descr.hamlet")
{-
getListaR :: Handler Html
getListaR = do
    -- Handler [Entity ProdutoId Produto]
    produtos <- runDB $ selectList [] [Desc ProdutoValor]
    defaultLayout $ do
        $(whamletFile "templates/listar.hamlet")

        -}