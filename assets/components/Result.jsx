import React, { PropTypes } from 'react';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { ocean } from 'react-syntax-highlighter/dist/styles';

Result.propTypes = {
  style: PropTypes.object,
  fetching: PropTypes.bool,
  result: PropTypes.string.isRequired
}

export default function Result({ style = {}, fetching = false, result = "" }){
  const innerStyle = {
    fontFamily: "monospace",
    fontSize: 14,
    height: "100%"
  }
  return(
    <div style={style}>
      <SyntaxHighlighter language="json" style={ocean} customStyle={innerStyle}>
        {fetching ? "Loading..." : result}
      </SyntaxHighlighter>
    </div>
  )
}
