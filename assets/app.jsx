import React from 'react';
import ReactDOM from 'react-dom';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';
import store from 'store';

class App extends React.Component {
  constructor(...props){
    super(...props)
    this.state = {
      source: store.get("source"),
      result: "",
      fetching: false,
    };
  }

  setSource = e => {
    const source = e.target.value
    store.set('source', source);
    this.setState({ source })
  }

  submit = e => {
    if (e) { e.preventDefault() }
    this.setState({ fetching: true })
    fetch('/generate', {
      method: 'POST',
      body: this.state.source,
      headers: new Headers({
        'Content-Type': 'application/yaml'
      })
    }).then(
      r => r.text()
    ).then(
      text => this.setState({ result: text, fetching: false })
    );
  }

  componentDidMount(){
    if (this.state.source) {
      this.submit();
    }
  }

  render(){
    const margin = 10;
    const buttonSize = 50;
    const outerStyle = {
      margin: 0,
      width: "50vw",
      height: "100vh",
      float: "left",
      overflow: "scroll",
    }
    const innerStyle = {
      fontFamily: "monospace",
      fontSize: 14,
      height: "100%"
    }
    const innerInputStyle = {
      ...innerStyle,
      margin,
      padding: 0,
      width: `calc(100% - ${margin * 2}px)`,
      height: `calc(100% - ${margin * 2}px)`,
      border: 0,
      resize: "none",
      backgroundColor: "transparent"
    }
    const sourceStyle = {
      ...outerStyle,
      backgroundColor: "#ccc"
    }
    const buttonStyle = {
      borderRadius: (buttonSize / 2),
      cursor: "pointer",
      backgroundColor: this.state.fetching ? "#ff6" : "#07f",
      position: "absolute",
      width: buttonSize,
      height: buttonSize,
      left: "50%",
      top: "50%",
      marginLeft: -(buttonSize / 2),
      marginTop: -(buttonSize / 2),
      zIndex: 99,
      color: this.state.fetching ? "#000" : "#fff",
      textAlign: "center",
      lineHeight: `${buttonSize}px`,
      fontSize: `${this.state.fetching ? 15 : buttonSize / 2}px`
    }
    return (
      <div>
        <form style={sourceStyle} onSubmit={this.submit}>
          <textarea onChange={this.setSource} style={innerInputStyle} value={this.state.source} />
        </form>
        <div onClick={this.submit} style={buttonStyle}>{this.state.fetching ? "..." : ">"}</div>
        <div style={outerStyle}>
          <SyntaxHighlighter language="json" style={ocean} customStyle={innerStyle}>
            {this.state.loading ? "Loading..." : this.state.result}
          </SyntaxHighlighter>
        </div>
      </div>
    )
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
