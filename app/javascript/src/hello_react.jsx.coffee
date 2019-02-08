# Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
# like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
# of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import "./hello_react.scss"

# Unfortunately this doesn't seem to be compiled by JSX properly
# we probably need some loader to go .jsx.coffee -> .jsx -> .js
Hello = (props) =>
  <div className="hello-name">Hello {props.name}!</div>

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
}

document.addEventListener 'DOMContentLoaded', () =>
  ReactDOM.render(<Hello name="React" />,
    document.body.appendChild(document.createElement('div')))

alert "hello"

export default Hello
