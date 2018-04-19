import React from 'react';
import ReactDOM from 'react-dom';
import Header from './components/Header';
import Generator from './components/Generator';

const style = {
  position: "fixed",
  flexDirection: "column",
  top: 0,
  bottom: 0,
  left: 0,
  right: 0,
  display: "flex",
  alignItems: "stretch",
  alignContent: "stretch",
  justifyContent: "space-between"
}

const generatorStyle = {
  display: "flex",
  alignItems: "stretch",
  alignContent: "stretch",
  justifyContent: "space-between",
  minHeight: "100%"
}

const App = () =>
  <div style={style}>
    <Header style={{ height: 30 }} />
    <Generator style={generatorStyle} />
  </div>

ReactDOM.render(<App />, document.getElementById("root"));
