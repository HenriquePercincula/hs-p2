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
formProduto :: Maybe Produto -> Form Produto
formProduto mp = renderBootstrap3 BootstrapBasicForm{- ou renderDivs-} $ Produto 
    <$> areq textField (FieldSettings  "Nome: " 
                                                Nothing
                                                (Just "h21")
                                                Nothing
                                                [("class","minhaClasse")]) 
                                                (fmap produtoNome mp) 
    <*> areq doubleField "Preco: " (fmap produtoValor mp) 
 
auxProdutoR :: Route App -> Maybe Produto -> Handler Html
auxProdutoR rt mp = do
    -- formWidget TERA TODAS AS TAGS DE FORMULARIO
    (formWidget, _) <- generateFormPost (formProduto mp)
    defaultLayout $ do
        -- pasta: static/css/bootstrap.css
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_estilo_css)
        toWidgetHead $(luciusFile "templates/descr.lucius")
        [whamlet|
            <form action=@{rt} method=post>
                ^{formWidget}
                <input type="submit" value="OK" style="border:none; padding:5px 20px; border-radius:5%;background-color:#f44;color:white">
        |]

getProdutoR :: Handler Html
getProdutoR = auxProdutoR ProdutoR Nothing

postProdutoR :: Handler Html
postProdutoR = do
    ((result, _), _) <- runFormPost (formProduto Nothing)
    case result of
        FormSuccess produto -> do
            pid <- runDB $ insert produto
            redirect (DescR pid)
        _-> redirect HomeR

formQt :: Form Int
formQt = renderBootstrap3 BootstrapBasicForm (areq intField "Quantidade: " (Just 1))
   
getDescR :: ProdutoId -> Handler Html
getDescR pid = do
    produto <- runDB $ get404 pid
    (widget, _) <- generateFormPost formQt
    defaultLayout $ do
        $(whamletFile "templates/descr.hamlet")

getListaR :: Handler Html
getListaR = do
    -- Handler [Entity ProdutoId Produto]
    produtos <- runDB $ selectList [] [Desc ProdutoValor]
    defaultLayout $ do
        $(whamletFile "templates/listar.hamlet")

getUpdProdR :: ProdutoId -> Handler Html
getUpdProdR pid = do
    antigo <- runDB $ get404 pid
    auxProdutoR (UpdProdR pid) (Just antigo)

-- update from produto set... where id = pid
postUpdProdR :: ProdutoId -> Handler Html
postUpdProdR pid = do
    ((result, _), _) <- runFormPost (formProduto Nothing)
    case result of
        FormSuccess produto -> do
            runDB $ replace pid produto
            redirect ListaR
        _-> redirect HomeR

postDelProdR :: ProdutoId -> Handler Html
postDelProdR pid = do
    runDB $ delete pid
    redirect ListaR