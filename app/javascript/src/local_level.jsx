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

class LocalLevel extends React.Component {
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

    // returns a string, not React
    const renderMonsters = (monsters) => {
      let monsterText = monsters.map((monster) => (
        `${monster.type} (${monster.health} hp)`
      ));

      return monsterText.join(", ");
    };

    const renderTile = (tile) => {
      // (...); is necessary for .jsx syntax.
      // {...; return X} is necessary to be a valid function
      //   AND to have if/lets/vars inside the block!
      let tileText = [];

      if (tile.monsters.length > 0) {
        tileText.push(renderMonsters(tile.monsters));
      }

      if (tile.x == this.props.data.player.x && tile.y == this.props.data.player.y) {
        tileText.push("(you're here!)");
      }

      let tileClasses = ["tile"];
      let tileContent = TILE_CLASSES[parseInt(tile.tile, 10)];
      tileClasses.push(tileContent || "unknown");

      let button = "";
      if (tile.visit_path) {
        button = <a className="visit" href={tile.visit_path} data-method="post">visit</a>
      }

      return (
        <td key={tile.x + "," + tile.y} className={tileClasses.join(" ")}>
          <small className="debug">({tile.x}, {tile.y})</small>
          {tileText.join(" ")}
          {button}
        </td>
      );
    };

    const renderRow = (row, index) => {
      return <tr key={"row" + index}>
        { row.map(renderTile) }
      </tr>
    };

    return <table className="local-level">
        <tbody>
          { this.props.data.tiles.map(renderRow) }
        </tbody>
      </table>
  }
}

export default LocalLevel;
