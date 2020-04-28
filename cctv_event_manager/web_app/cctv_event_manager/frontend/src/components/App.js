import React, { Component } from 'react';
import ReactDOM from "react-dom";
import { EventList } from './EventList'
import store from "../store";
import { Provider as ReduxProvider } from 'react-redux';
import Header from './layout/Header';

//import '../App.css';

class App extends Component{

  render(){
    return (
      <ReduxProvider  store={store}>
        <div className="App">
          <Header/>
          <EventList/>
        </div>
      </ReduxProvider>
    )
  }
}

ReactDOM.render(<App />, document.getElementById('app'));