import React from 'react';
import ReactDOM from 'react-dom';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';
import deepSort from 'deep-sort-object';

class App extends React.Component {
  constructor(...props){
    super(...props)
    this.state = {
      source: "",
      result: "",
      fetching: false,
    };
  }

  setSource = e => {
    clearTimeout(this.submitTimeout);
    this.submitTimeout = setTimeout(this.submit, 100);
    const source = e.target.value;
    window.location.hash = source ? btoa(source) : '';
    this.setState({ source })
  }

  handleNewHash = () => {
    try {
      this.setState({ source: atob(window.location.hash.replace(/^#/, "")) }, this.submit)
    } catch (e) {
      window.location.hash = ''
    }
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
    window.addEventListener('hashchange', this.handleNewHash, false);
    this.handleNewHash();
    if (this.state.source) {
      this.submit();
    }
  }

  componentWillUnmount(){
    window.removeEventListener('hashchange', this.handleNewHash, false);
  }

  render(){
    const { fetching, result, source } = this.state;
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
      overflow: "visible",
      width: `calc(100% - ${margin * 2}px)`,
      height: `calc(100% - ${margin * 2}px)`,
      border: 0,
      resize: "none",
      backgroundColor: "transparent",
      backgroundImage: fetching ? 'url("/duck.png")' : 'none',
      backgroundRepeat: "no-repeat",
      backgroundPosition: "right top",
      transition: "background-image 1s"
    }
    const sourceStyle = {
      ...outerStyle,
      backgroundColor: "#ccc"
    }
    return (
      <div>
        <form style={sourceStyle} onSubmit={this.submit}>
          <textarea spellCheck={false} onChange={this.setSource} style={innerInputStyle} value={source} />
        </form>
        <div style={outerStyle}>
          <SyntaxHighlighter language="json" style={ocean} customStyle={innerStyle}>
            {result}
          </SyntaxHighlighter>
        </div>
      </div>
    )
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
