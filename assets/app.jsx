import React from 'react';
import ReactDOM from 'react-dom';
import Header from './components/Header';
import Generator from './components/Generator';

const App = () =>
  <div>
    <Header />
    <Generator />
  </div>

ReactDOM.render(<App />, document.getElementById("root"));
