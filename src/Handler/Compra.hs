{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Compra where

import Import

import Handler.Tools
import Database.Persist.Sql

getListCompraR :: Handler Html
getListCompraR = do
    sess <- lookupSession "_ID"
    case sess of
        Nothing -> redirect HomeR
        Just email -> do
            usu <- runDB $ getBy (UniqueEmail email)
            case usu of
                Nothing -> redirect HomeR
                Just (Entity uid usuario) -> do
                    let sql = "SELECT ??,??,?? FROM usuario \
                        \ INNER JOIN compra ON compra.usuarioid = usuarioid\
                        \ INNER JOIN produto ON compra.produtoid = produtoid\
                        \ WHERE usuario.id = ?"
                    produtos <- runDB $ rawSql sql [toPersistValue uid] :: Handler [(Entity Usuario, Entity Compra, Entity Produto)]
                    defaultLayout $ do
                        [whamlet|
                            <h1>
                                COMPRAS de #{usuarioEmail usuario}
                            
                            <ul>
                                $forall (Entity _ _, Entity _ compra, Entity _ produto) <- produtos
                                    <li>
                                        #{produtoNome produto}: #{produtoValor produto * (fromIntegral (compraQtunit compra))}
                        |]

postCompraR :: ProdutoId -> Handler Html
postCompraR pid = do
    ((resp,_),_) <- runFormPost formQt
    case resp of
        FormSuccess qt -> do
            sess <- lookupSession "_ID"
            case sess of
                Nothing -> redirect HomeR
                Just email -> do
                    usuario <- runDB $ getBy (UniqueEmail email)
                    case usuario of
                        Nothing -> redirect HomeR
                        Just (Entity uid _) -> do
                            runDB $ insert (Compra pid uid qt)
                            redirect ListCompraR
        _ -> redirect HomeR

