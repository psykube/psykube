import React from 'react';
import store from "store"
import Source from './Source';
import Result from './Result';

const outerStyle = {
  position: "relative",
  margin: 0,
  flexDirection: "column",
  display: "flex",
  alignItems: "stretch",
  alignContent: "stretch",
  justifyContent: "space-between",
  maxHeight: "100%",
  width: "50%",
  overflow: "scroll",
}

export default class Generator extends React.Component {
  constructor(...props){
    super(...props)
    this.state = {
      error: null,
      clusters: [],
      cluster: null,
      source: "",
      result: "",
      fetching: false,
    };
  }

  handleSourceChange = e => {
    this.setSource(e.target.value);
  }

  handleClusterChange = e => {
    this.setCluster(e.target.value);
  }

  setSource = source => {
    clearTimeout(this.submitTimeout);
    this.submitTimeout = setTimeout(this.submit, 500);
    this.setState({ source })
  }

  setCluster = cluster => {
    clearTimeout(this.submitTimeout);
    this.submitTimeout = setTimeout(this.submit, 500);
    this.setState({ cluster })
  }

  handleNewHash = () => {
    try {
      this.setSource(atob(window.location.hash.replace(/^#/, "")))
    } catch (e) {
      window.location.hash = ''
    }
  }

  submit = () => {
    const { source, cluster } = this.state;
    clearTimeout(this.submitTimeout)
    this.setState({ fetching: true })
    this.activeFetch =
      fetch(`/generate${cluster ? `?cluster=${cluster}` : ''}`, {
        method: 'POST',
        body: this.state.source,
        headers: new Headers({
          'Content-Type': 'application/yaml'
        })
      })
      .then(r => r.json())
      .then(({ result = "", clusters = [], current_cluster = null, error = null }) => {
        this.setState({ result, clusters, cluster: current_cluster, error, fetching: false })
        store.set("source", source);
        window.location.hash = source ? btoa(source) : '';
      })
      .catch(
        ({ message: error }) => this.setState({ error, fetching: false })
      );
  }

  componentDidMount(){
    window.location.hash ? this.handleNewHash() : this.setSource(store.get("source"));
  }

  render = () =>
    <div {...this.props}>
      <Source style={{ ...outerStyle, backgroundColor: "#ddd" }} source={this.state.source} onChange={this.handleSourceChange} />
      <Result style={outerStyle} {...this.state} onClusterChange={this.handleClusterChange} />
    </div>
}
