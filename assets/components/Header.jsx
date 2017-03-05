import React, { PropTypes } from 'react';

Header.propTypes = {
  style: PropTypes.object
}

export default function Header({ style: styleProp ,...props }){
  const style = {
    padding: 10,
    fontSize: "30px",
    lineHeight: "30px",
    backgroundColor: "#457",
    color: "#fff",
    ...styleProp
  }
  return(
    <header style={style} {...props}>
      Psykube Playground
    </header>
  )
}
