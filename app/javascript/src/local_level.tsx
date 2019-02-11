import * as React from 'react'
import * as ReactDOM from 'react-dom'
import * as PropTypes from 'prop-types'

import "./local_level.scss"

const TILE_CLASSES = {
  0: "void",
  1: "wall",
  2: "floor",
};

interface IPlayer {
  x: number;
  y: number;
};

interface ITile {
  x:          number;
  y:          number;
  tile:       string;
  visit_path: string;
  monsters: {
    type:   string;
    health: number;
  }[];
};

interface TileProps {
  parent: LocalLevel;
  player: IPlayer;
  tile:   ITile;
}

class Tile extends React.PureComponent<TileProps> {
  props: TileProps;

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
          this.props.parent.setState({
            tiles:           response.level.tiles,
            player:          response.level.player,
            somethingRandom: true,  // ... does not fail, because setState accepts ANY input
          });
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

    let button;
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

interface LocalLevelState {
  messages: string[];
  errors:   string[];
  tiles:    ITile[][];
  player:   IPlayer;
}

class LocalLevel extends React.PureComponent<{ data: LocalLevelState }> {
  state: LocalLevelState;

  constructor(props: { data: LocalLevelState }) {
    super(props);

    this.state = props.data;
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

    const renderRow = (row: ITile[], index: number) => {
      // (...); is necessary for .jsx syntax.
      // {...; return X} is necessary to be a valid function
      //   AND to have if/lets/vars inside the block!

      const tableTiles = row.map((tile: ITile) =>
        <Tile key={tile.x + "," + tile.y} tile={tile} player={this.state.player} parent={this} />
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
          { this.state.tiles.map(renderRow) }
        </tbody>
      </table>
    </div>);
  }
}

export default LocalLevel;
