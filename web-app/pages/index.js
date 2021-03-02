import React, { Component } from "react"
import fetch from "isomorphic-unfetch"

export default class extends Component {
  render () {
    return (
      <div>Your Next.js App</div>
    )
  }

  static async getInitialProps() {
    const res = await fetch("https://162.243.205.13/woof.json?filter=mp4,webm")
    const data = await res.json()

    return {
      imageURL: data.url
    }
  }

  render () {
    return (
      <div className="homepage-wrapper">
        <h1>Random Dog Image V1</h1>
        <img src={this.props.imageURL} />
      </div>
    )
  }
}
