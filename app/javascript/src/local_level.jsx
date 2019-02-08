import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import "./local_level.scss"

const TILE_CLASSES = {
  0: "void",
  1: "wall",
  2: "floor",
};

class Tile extends React.Component {
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
      button = <a className="visit" href={this.props.tile.visit_path} data-method="post">visit</a>
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
        <Tile key={tile.x + "," + tile.y} tile={tile} player={this.props.data.player} />
      );

      return <tr key={"row" + index}>
        { tableTiles }
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
