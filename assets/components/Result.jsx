import React, { Component, PropTypes } from 'react';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';

export default class Result extends Component {
  static propTypes = {
    style: PropTypes.object,
    fetching: PropTypes.bool,
    error: PropTypes.string,
    result: PropTypes.string.isRequired
  }

  constructor(...props){
    super(...props);
    this.state = {
      showError: false,
    }
  }

  renderErrors(){
    return this.props.error ? ("// " + this.props.error + "\n") : ""
  }

  render(){
    const { style = {}, fetching = false, error = "", result = "" } = this.props;
    const statusStyle = {
      position: "absolute",
      top: 10,
      right: 10,
      width: 20,
      height: 20,
      borderRadius: 10,
      backgroundColor: fetching ? "yellow" : error ? "red" : "green"
    }
    const innerStyle = {
      fontFamily: "monospace",
      fontSize: 14,
      height: "100%"
    }
    return(
      <div style={style}>
        <div style={statusStyle} />
        <SyntaxHighlighter language="yaml" style={ocean} customStyle={innerStyle}>
          {this.renderErrors() + result}
        </SyntaxHighlighter>
      </div>
    )
  }
}
