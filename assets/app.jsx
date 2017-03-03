import React from 'react';
import ReactDOM from 'react-dom';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';
import store from 'store';
import deepSort from 'deep-sort-object';

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
    clearTimeout(this.submitTimeout);
    this.submitTimeout = setTimeout(this.submit, 100);
    const source = e.target.value;
    store.set('source', source);
    this.setState({ source })
  }

  submit = () => {
    clearTimeout(this.submitTimeout)
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
      text => new Promise(
        r => r(JSON.stringify(deepSort(JSON.parse(text)), null, 2))
      ).catch(() => text)
    ).then(
      result => this.setState({ result, fetching: false })
    );
  }

  componentDidMount(){
    if (this.state.source) {
      this.submit();
    }
  }

  render(){
    const margin = 10;
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
    return (
      <div>
        <form style={sourceStyle} onSubmit={this.submit}>
          <textarea onChange={this.setSource} style={innerInputStyle} value={this.state.source} />
        </form>
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
