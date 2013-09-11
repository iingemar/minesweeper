package  {	
	// Importing classes
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends Sprite {
		// Class level variables
		private const FIELD_W:uint = 9;
		private const FIELD_H:uint = 9;
		private const NUM_MINES:uint = 10;
		private var mineField:Array = new Array();
		private var game_container:Sprite = new Sprite();
		private var tile:tile_movieclip;
		// Tiles
		private const UNCLICKED:uint = 1;						
		private const NUMBER:uint = 2;				
		private const FLAG:uint = 3;				
		private const MINE:uint = 4;		
		private const EMPTY:uint = 5;

		private function printField() {
			for (var i:uint=0; i<FIELD_H; i++) {
				trace("Row " + i + ": " + mineField[i]);
			}
			trace("--");
		}
		
		private function tileValue(row:uint, col:uint):int {
			if (mineField[row] == undefined || mineField[row][col] == undefined) {
				return -1;
			} else {
				return mineField[row][col];
			}
		}
		
		private function onTileClick(e:MouseEvent) {
			// Get clicked tile
			var clicked_tile:tile_movieclip = e.currentTarget as tile_movieclip;
			// Remove mouse click listener
			clicked_tile.removeEventListener(MouseEvent.CLICK, onTileClick);
			// Remove mouse pointer
			clicked_tile.buttonMode = false;
			
			// Get row and columns
			var row:uint = e.currentTarget.nrow;
			var col:uint = e.currentTarget.ncol;
			// Get the mine field type
			var field:uint = mineField[row][col];
			
			// Three cases
			// 1. Nothing in adjacent tiles
			if (field == 0) {
				trace("nothing");
				e.currentTarget.gotoAndStop(EMPTY);				
			// 2. One to eight adjacent mines				
			} else if (field > 0 && field < 9) {
				trace(field);				
				e.currentTarget.gotoAndStop(NUMBER);
			// 3. Mine				
			} else if (field == 9) {
				trace("mine");								
				e.currentTarget.gotoAndStop(MINE);
			}
		}

		public function Main() {
			// Create empty mine field
			for (var i:uint=0; i<FIELD_H; i++) {
				mineField[i] = new Array();
				for (var j:uint=0; j<FIELD_W; j++) {
					mineField[i].push(0);
				}
			}
			
			printField();
			
			// Add mines
			var placedMines:uint = 0;
			var randomRow:uint = 0;
			var randomColumn:uint = 0;
			while (placedMines < NUM_MINES) {
				randomRow = Math.random() * FIELD_H;
				randomColumn = Math.random() * FIELD_W;
				// If empty spot
				if (mineField[randomRow][randomColumn] == 0) {
					mineField[randomRow][randomColumn] = 9;
					placedMines++;
				}
			}
			
			printField();
			
			// Counting neighbors
			for (i=0; i<FIELD_H; i++) {
				for (j=0; j<FIELD_W; j++) {
					if (mineField[i][j] == 9) {
						// left
						// if not at left most column
						// AND field to left is not a mine
						if (j != 0 && mineField[i][j-1] != 9) {
							mineField[i][j-1]++;
						}
						// right
						if (j != 8 && mineField[i][j+1] != 9) {
							mineField[i][j+1]++;
						}
						// up
						if (i != 0 && mineField[i-1][j] != 9) {
							mineField[i-1][j]++;
						}
						// down
						if (i != 8 && mineField[i+1][j] != 9) {
							mineField[i+1][j]++;
						}
						// up left
						if (i != 0 && j != 0 && mineField[i-1][j-1] != 9) {
							mineField[i-1][j-1]++;
						}
						// up right
						if (i != 8 && j != 8 && mineField[i+1][j+1] != 9) {
							mineField[i+1][j+1]++;
						}
						// bottom left
						if (i != 8 && j != 0 && mineField[i+1][j-1] != 9) {
							mineField[i+1][j-1]++;
						}												
						// bottom right
						if (i != 0 && j != 8 && mineField[i-1][j+1] != 9) {
							mineField[i-1][j+1]++;
						}						
					}
				}
			}
			
			printField();
			
			addChild(game_container);
			
			// Create tile gfx
			for (i=0; i<FIELD_H; i++) {
				for (j=0; j<FIELD_W; j++) {
					tile = new tile_movieclip();
					tile.gotoAndStop(1);
					tile.nrow = i;
					tile.ncol = j;
					tile.buttonMode = true;
					tile.x = 20 * j;
					tile.y = 20 * i;
					tile.addEventListener(MouseEvent.CLICK, onTileClick);
					game_container.addChild(tile);
				}
			}
		}
	}
}
