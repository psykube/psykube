import React from 'react';
import deepSort from 'deep-sort-object';
import Source from './Source';
import Result from './Result';

const outerStyle = {
  margin: 0,
  width: "50vw",
  height: "100vh",
  float: "left",
  overflow: "scroll",
}

export default class Generator extends React.Component {
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

  render = () =>
    <div {...this.props}>
      <Source style={{ ...outerStyle, backgroundColor: "#ddd" }} fetching={this.state.fetching} source={this.state.source} onChange={this.setSource} />
      <Result style={outerStyle} fetching={this.state.fetching} result={this.state.result} />
    </div>
}
