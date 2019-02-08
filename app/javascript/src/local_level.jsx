import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import "./local_level.scss"

// ------------- INCORRECT:
// You cannot render React components passing along objects as keys. They have to all be native. Ugh.
//
// class Tile extends React.Component { // alt: import { Component } from 'react', and use Component here directly
//   render() {
//     return <td>
//       {this.props.tile}
//     </td>
//   }
// }

// class Row extends React.Component {
//   render() {
//     return <tr>
//       { this.props.row.map((tile, index) => (
//         <Tile key={tile.x + "_" + tile.y} tile={tile} />
//       ))}
//     </tr>
//   }
// }

// class LocalLevel extends React.Component {
//   render() {
//     return <table>
//       { this.props.data.tiles.map((row, index) => (
//         // {...x} destructs all keys of X to the parent component
//         <Row key={index} row={row} />
//       ))}
//     </table>
//   }
// }
// -------------

// Correct: You need to render everything as once.

const TILE_CLASSES = {
  0: "void",
  1: "wall",
  2: "floor",
};

class Tile extends React.Component {
  handleVisit = (e) => {
    let path = this.props.tile.visit_path;

    if (!this.props.parent) {
      throw "No parent defined for Tile; any successful result could not be rendered";
    }

    // new fetch API c.f. jQuery
    fetch(path, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content'),
      },
    })
      .then((response) => response.json()) // convert Promise to JSON (???)
      .then((response) => {
        this.props.parent.setState({
          messages: response.messages,
          errors:   response.errors,
        });

        if (response.level) {
          this.props.parent.setState({ data: response.level });
        };
      });
  };

  render() {
    // returns a string, not React
    const renderMonsters = (monsters) => {
      let monsterText = monsters.map((monster) => (
        `${monster.type} (${monster.health} hp)`
      ));

      return monsterText.join(", ");
    };

    let tileText = [];

    if (this.props.tile.monsters.length > 0) {
      tileText.push(renderMonsters(this.props.tile.monsters));
    }

    if (this.props.tile.x == this.props.player.x && this.props.tile.y == this.props.player.y) {
      tileText.push("(you're here!)");
    }

    let tileClasses = ["tile"];
    let tileContent = TILE_CLASSES[parseInt(this.props.tile.tile, 10)];
    tileClasses.push(tileContent || "unknown");

    let button = "";
    if (this.props.tile.visit_path) {
      // NOTE if you use data-method, then onClick will never be called (Chrome)

      button = <button className="visit"
          onClick={this.handleVisit}
        >
          visit
        </button>
    }

    return (
      <td key={this.props.tile.x + "," + this.props.tile.y} className={tileClasses.join(" ")}>
        <small className="debug">({this.props.tile.x}, {this.props.tile.y})</small>
        {tileText.join(" ")}
        {button}
      </td>
    );
  }
}

class LocalLevel extends React.Component {
  constructor(props) {
    super(props);

    this.state = { data: props.data };
  }

  render() {
    // valid, but ugh, so many loops
    // return <table>
    //   <tbody>
    //   { this.props.data.tiles.map((row, index) => (
    //     <tr key={"row" + index}>
    //       { row.map((tile) => (
    //         <td key={tile.x + "," + tile.y}>
    //           { tile.tile } (with { tile.monsters.length } monsters)
    //         </td>
    //       )) }
    //     </tr>
    //   )) }
    //   </tbody>
    // </table>

    const renderRow = (row, index) => {
      // (...); is necessary for .jsx syntax.
      // {...; return X} is necessary to be a valid function
      //   AND to have if/lets/vars inside the block!

      const tableTiles = row.map((tile) =>
        <Tile key={tile.x + "," + tile.y} tile={tile} player={this.state.data.player} parent={this} />
      );

      return <tr key={`row${index}`}>
        { tableTiles }
      </tr>
    };

    const messages = (() => {
      if (this.state.messages) {
        return (
          <div className="notice">{this.state.messages}</div>
        );
      }
    });

    const errors = (() => {
      if (this.state.errors) {
        return (
          <div className="error">{this.state.errors}</div>
        );
      }
    });

    return (<div>
      <div className="message-bar">
        {messages()}
        {errors()}
      </div>

      <table className="local-level">
        <tbody>
          { this.state.data.tiles.map(renderRow) }
        </tbody>
      </table>
    </div>);
  }
}

export default LocalLevel;
