require "rails_helper"

RSpec.describe GenerateLevel do
  include UserSupport

  let(:game) { default_user.games.create! }

  context "setting width and height to 5" do
    let(:service) { GenerateLevel.new(game: game, depth: depth, width: width, height: height) }
    let(:width) { 5 }
    let(:height) { 5 }
    let(:depth) { 1 }

    describe "#call" do
      let!(:level) { service.call }

      it "is a valid level" do
        expect(level).to be_valid
      end
    end

    describe "#empty_tiles" do
      let(:tiles) { service.send(:empty_tiles, width, height) }

      it "are all empty" do
        expect(tiles).to eq [
          [ Tile::EMPTY ] * 5
        ] * 5
      end
    end

    describe "#fill_rect!" do
      let(:tiles) { service.send(:empty_tiles, width, height) }

      it "can fill a 3x3 rect" do
        service.send(:fill_rect!, tiles, Tile::WALL, from_x: 1, from_y: 1, to_x: 3, to_y: 3)

        expect(tiles).to eq [
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
        ]
      end

      it "can fill a 3x3 rect in reverse" do
        service.send(:fill_rect!, tiles, Tile::WALL, from_x: 3, from_y: 3, to_x: 1, to_y: 1)

        expect(tiles).to eq [
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
        ]
      end
    end

    describe "#draw_rect!" do
      let(:tiles) { service.send(:empty_tiles, width, height) }

      it "can draw a 3x3 rect" do
        service.send(:draw_rect!, tiles, Tile::WALL, from_x: 1, from_y: 1, to_x: 3, to_y: 3)

        expect(tiles).to eq [
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::EMPTY, Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
        ]
      end

      it "can draw a 3x1 line" do
        service.send(:draw_rect!, tiles, Tile::WALL, from_x: 1, from_y: 1, to_x: 3, to_y: 1)

        expect(tiles).to eq [
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::WALL,  Tile::WALL,  Tile::WALL,  Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
          [ Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, Tile::EMPTY, ],
        ]
      end
    end
  end
end
