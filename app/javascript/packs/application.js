/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Prob need to use WebpackerReact only from root packs
import WebpackerReact from 'webpacker-react'
//import Turbolinks from 'turbolinks'
Turbolinks.start()

import "src/application.scss"

console.log('Hello World from Webpacker')

import Hello from "src/hello_react"
WebpackerReact.setup({ Hello })

import LocalLevel from "src/local_level"
WebpackerReact.setup({ LocalLevel })
