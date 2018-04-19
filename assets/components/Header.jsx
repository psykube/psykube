import React from 'react';
import PropTypes from 'prop-types';

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
