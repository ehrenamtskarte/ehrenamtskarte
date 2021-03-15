import React from 'react';
import Navigation from "./components/Navigation";
import "normalize.css";
import "@blueprintjs/core/lib/css/blueprint.css";
import "@blueprintjs/icons/lib/css/blueprint-icons.css";
import {ApolloClient, ApolloProvider, InMemoryCache} from "@apollo/client";
import {HashRouter, Route} from "react-router-dom";
import GenerationController from "./components/generation/GenerationController";
import styled from "styled-components";
import RegionProvider from "./RegionProvider";

const client = new ApolloClient({
    uri: 'http://localhost:7000',
    cache: new InMemoryCache()
});

const Main = styled.div`
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
`


const App = () =>
    <ApolloProvider client={client}>
        <RegionProvider>
            <HashRouter>
                <Navigation/>
                <Main>
                    <Route exact path={"/"}>

                    </Route>
                    <Route path={"/eak-generation"}>
                        <GenerationController/>
                    </Route>
                    <Route path={"/accepting-stores"}>

                    </Route>
                </Main>
            </HashRouter>
        </RegionProvider>
    </ApolloProvider>

export default App;
