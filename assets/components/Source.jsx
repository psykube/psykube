import React, { PropTypes } from 'react';

Source.propTypes = {
  style: PropTypes.object,
  margin: PropTypes.number,
  fetching: PropTypes.bool,
  source: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired
}

export default function Source({ style = {}, margin = 10, fetching = false, source = "", onChange = () => {} }){
  const innerStyle = {
    margin,
    fontFamily: "monospace",
    fontSize: 14,
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
  return(
    <div style={style}>
      <textarea spellCheck={false} onChange={onChange} style={innerStyle} value={source} />
    </div>
  )
}
