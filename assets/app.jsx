import React from 'react';
import ReactDOM from 'react-dom';
import Header from './components/Header';
import Generator from './components/Generator';

const App = () =>
  <div>
    <Header style={{ height: 30 }} />
    <Generator style={{ height: "calc(100vh - 50px)" }} />
  </div>

ReactDOM.render(<App />, document.getElementById("root"));
