import React from 'react';
import deepSort from 'deep-sort-object';
import store from "store"
import Source from './Source';
import Result from './Result';

const outerStyle = {
  position: "relative",
  margin: 0,
  width: "50%",
  height: "100%",
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

  handleSourceChange = e => {
    this.setSource(e.target.value);
  }

  setSource = source => {
    clearTimeout(this.submitTimeout);
    this.submitTimeout = setTimeout(this.submit, 500);
    this.setState({ source })
  }

  handleNewHash = () => {
    try {
      this.setSource(atob(window.location.hash.replace(/^#/, "")))
    } catch (e) {
      window.location.hash = ''
    }
  }

  submit = () => {
    const { source } = this.state;
    clearTimeout(this.submitTimeout)
    this.setState({ fetching: true })
    this.activeFetch = fetch('/generate', {
      method: 'POST',
      body: this.state.source,
      headers: new Headers({
        'Content-Type': 'application/yaml'
      })
    }).then(r => r.text())
    const f = this.activeFetch;
    f.then(
      () => this.activeFetch
    ).then(
      text => new Promise(
        r => r(JSON.stringify(deepSort(JSON.parse(text)), null, 2))
      ).catch(() => {
        throw new Error(text);
      })
    ).then(
      result => {
        this.setState({ result, error: "", fetching: false })
        store.set("source", source);
        window.location.hash = source ? btoa(source) : '';
      }
    ).catch(
      ({ message: error }) => this.setState({ error, fetching: false })
    );
  }

  componentDidMount(){
    window.location.hash ? this.handleNewHash() : this.setSource(store.get("source"));
  }

  render = () =>
    <div {...this.props}>
      <Source style={{ ...outerStyle, backgroundColor: "#ddd" }} source={this.state.source} onChange={this.handleSourceChange} />
      <Result style={outerStyle} fetching={this.state.fetching} result={this.state.result} error={this.state.error} />
    </div>
}
