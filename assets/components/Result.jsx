import React from 'react';
import PropTypes from 'prop-types';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';

export default class Result extends React.Component {
  static propTypes = {
    style: PropTypes.object,
    fetching: PropTypes.bool,
    error: PropTypes.string,
    result: PropTypes.string.isRequired,
    clusters: PropTypes.arrayOf(PropTypes.string),
    current_cluster: PropTypes.string,
    onClusterChange: PropTypes.func.isRequired,
  }

  constructor(...props){
    super(...props);
    this.state = {
      showError: false,
    }
  }

  renderErrors(){
    return this.props.error ? ("# " + this.props.error + "\n") : ""
  }

  renderClusters(){
    return this.props.clusters.map(
      cluster => <option key={cluster} value={cluster}>{cluster}</option>
    )
  }

  render(){
    const { style = {}, fetching = false, error = "", result = "" } = this.props;
    const statusStyle = {
      height: 3,
      width: "100%",
      backgroundColor: fetching ? "yellow" : error ? "red" : "green"
    }
    const innerStyle = {
      fontFamily: "monospace",
      fontSize: 14,
      height: this.props.clusters.length ? "calc(100% - 20px)" : "100%"
    }
    const clusterPickerStyle = {
      padding: 5,
      height: 20,
      backgroundColor: "#999",
      textAlign: "right",
      display: this.props.clusters.length ? "inline-block" : "none"
    }
    return(
      <div style={style}>
        <div style={clusterPickerStyle}>
          <label>cluster:</label>
          <select onChange={this.props.onClusterChange} value={this.props.current_cluster} style={{ marginLeft: 10 }}>
            {this.renderClusters()}
          </select>
        </div>
        <div style={statusStyle} />
        <SyntaxHighlighter language="yaml" style={ocean} customStyle={innerStyle}>
          {this.renderErrors() + result}
        </SyntaxHighlighter>
      </div>
    )
  }
}
