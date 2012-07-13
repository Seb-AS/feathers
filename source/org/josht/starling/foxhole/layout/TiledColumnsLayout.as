/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	/**
	 * Positions items as tiles (equal width and height) from top to bottom
	 * in multiple columns. Constrained to the suggested height, the tiled
	 * columns layout will change in width as the number of items increases or
	 * decreases.
	 */
	public class TiledColumnsLayout implements IVirtualLayout
	{
		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the top.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the middle.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the bottom.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the left.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the center.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the right.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the top edge of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the middle of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the bottom edge of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The item will be resized to fit the height of the tile.
		 */
		public static const TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the left edge of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the center of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the right edge of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The item will be resized to fit the width of the tile.
		 */
		public static const TILE_HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The items will be positioned in pages horizontally from left to right.
		 */
		public static const PAGING_HORIZONTAL:String = "horizontal";

		/**
		 * The items will be positioned in pages vertically from top to bottom.
		 */
		public static const PAGING_VERTICAL:String = "vertical";

		/**
		 * The items will not be paged. In other words, they will be positioned
		 * in a continuous set of columns without gaps.
		 */
		public static const PAGING_NONE:String = "none";

		/**
		 * Constructor.
		 */
		public function TiledColumnsLayout()
		{
		}

		/**
		 * @private
		 */
		private var _gap:Number = 0;

		/**
		 * The space, in pixels, between tiles.
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The space, in pixels, above of items.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The space, in pixels, to the right of the items.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The space, in pixels, below the items.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The space, in pixels, to the left of the items.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		/**
		 * If the total column height is less than the bounds, the items in the
		 * column can be aligned vertically.
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		/**
		 * If the total row width is less than the bounds, the items in the row
		 * can be aligned horizontally.
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _tileVerticalAlign:String = TILE_VERTICAL_ALIGN_MIDDLE;

		/**
		 * If an item's height is less than the tile bounds, the position of the
		 * item can be aligned vertically.
		 */
		public function get tileVerticalAlign():String
		{
			return this._tileVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set tileVerticalAlign(value:String):void
		{
			if(this._tileVerticalAlign == value)
			{
				return;
			}
			this._tileVerticalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _tileHorizontalAlign:String = TILE_HORIZONTAL_ALIGN_CENTER;

		/**
		 * If the item's width is less than the tile bounds, the position of the
		 * item can be aligned horizontally.
		 */
		public function get tileHorizontalAlign():String
		{
			return this._tileHorizontalAlign;
		}

		/**
		 * @private
		 */
		public function set tileHorizontalAlign(value:String):void
		{
			if(this._tileHorizontalAlign == value)
			{
				return;
			}
			this._tileHorizontalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paging:String = PAGING_NONE;

		/**
		 * If the total item size is larger than the view port, the items may
		 * be displayed as pages with gaps between items.
		 */
		public function get paging():String
		{
			return this._paging;
		}

		/**
		 * @private
		 */
		public function set paging(value:String):void
		{
			if(this._paging == value)
			{
				return;
			}
			this._paging = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _useVirtualLayout:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get useVirtualLayout():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @private
		 */
		public function set useVirtualLayout(value:Boolean):void
		{
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _typicalItemWidth:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemWidth():Number
		{
			return this._typicalItemWidth;
		}

		/**
		 * @private
		 */
		public function set typicalItemWidth(value:Number):void
		{
			if(this._typicalItemWidth == value)
			{
				return;
			}
			this._typicalItemWidth = value;
		}

		/**
		 * @private
		 */
		private var _typicalItemHeight:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemHeight():Number
		{
			return this._typicalItemHeight;
		}

		/**
		 * @private
		 */
		public function set typicalItemHeight(value:Number):void
		{
			if(this._typicalItemHeight == value)
			{
				return;
			}
			this._typicalItemHeight = value;
		}

		/**
		 * @private
		 */
		protected var _onLayoutChange:Signal = new Signal(ILayout);

		/**
		 * @inheritDoc
		 */
		public function get onLayoutChange():ISignal
		{
			return this._onLayoutChange;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, suggestedBounds:Rectangle, resultDimensions:Point = null):Point
		{
			if(!resultDimensions)
			{
				resultDimensions = new Point();
			}
			const itemCount:int = items.length;
			var tileSize:Number = Math.max(0, this._typicalItemWidth, this._typicalItemHeight);
			//a virtual layout assumes that all items are the same size as
			//the typical item, so we don't need to measure every item in
			//that case
			if(!this._useVirtualLayout)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					tileSize = Math.max(tileSize, item.width, item.height);
				}
			}

			var horizontalTileCount:int = 1;
			if(!isNaN(suggestedBounds.width))
			{
				horizontalTileCount = (suggestedBounds.width - this._paddingLeft - this._paddingRight + this._gap) / (tileSize + this._gap);
			}
			var verticalTileCount:int = itemCount;
			if(!isNaN(suggestedBounds.height))
			{
				verticalTileCount = (suggestedBounds.height - this._paddingTop - this._paddingBottom + this._gap) / (tileSize + this._gap);
			}

			const totalPageWidth:Number = horizontalTileCount * (tileSize + this._gap) - this._gap + this._paddingLeft + this._paddingRight;
			const totalPageHeight:Number = verticalTileCount * (tileSize + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
			const availablePageWidth:Number = isNaN(suggestedBounds.width) ? totalPageWidth : suggestedBounds.width;
			const availablePageHeight:Number = isNaN(suggestedBounds.height) ? totalPageHeight : suggestedBounds.height;

			const startX:Number = suggestedBounds.x + this._paddingLeft;
			const startY:Number = suggestedBounds.y + this._paddingTop;

			const perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartY:Number = startY;
			var positionX:Number = startX;
			var positionY:Number = startY;
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(i != 0 && i % verticalTileCount == 0)
				{
					positionX += tileSize + this._gap;
					positionY = pageStartY;
				}
				if(i == nextPageStartIndex)
				{
					//we're starting a new page, so handle alignment of the
					//items on the current page and update the positions
					if(this._paging != PAGING_NONE)
					{
						this.applyHorizontalAlign(items, i - perPage, i - 1, totalPageWidth, availablePageWidth);
						this.applyVerticalAlign(items, i - perPage, i - 1, totalPageHeight, availablePageHeight);
					}
					pageIndex++;
					nextPageStartIndex += perPage;
					if(this._paging == PAGING_HORIZONTAL)
					{
						positionX = startX + suggestedBounds.width * pageIndex;
					}
					else if(this._paging == PAGING_VERTICAL)
					{
						positionX = startX;
						positionY = pageStartY = startY + suggestedBounds.height * pageIndex;
					}
				}
				if(item)
				{
					switch(this._tileHorizontalAlign)
					{
						case TILE_HORIZONTAL_ALIGN_JUSTIFY:
						{
							item.x = positionX;
							item.width = tileSize;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_LEFT:
						{
							item.x = positionX;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_RIGHT:
						{
							item.x = positionX + tileSize - item.width;
							break;
						}
						default: //center or unknown
						{
							item.x = positionX + (tileSize - item.width) / 2;
						}
					}
					switch(this._tileVerticalAlign)
					{
						case TILE_VERTICAL_ALIGN_JUSTIFY:
						{
							item.y = positionY;
							item.height = tileSize;
							break;
						}
						case TILE_VERTICAL_ALIGN_TOP:
						{
							item.y = positionY;
							break;
						}
						case TILE_VERTICAL_ALIGN_BOTTOM:
						{
							item.y = positionY + tileSize - item.height;
							break;
						}
						default: //middle or unknown
						{
							item.y = positionY + (tileSize - item.height) / 2;
						}
					}
				}
				positionY += tileSize + this._gap;
			}
			//align the last page
			if(this._paging != PAGING_NONE)
			{
				this.applyHorizontalAlign(items, nextPageStartIndex - perPage, i - 1, totalPageWidth, availablePageWidth);
				this.applyVerticalAlign(items, nextPageStartIndex - perPage, i - 1, totalPageHeight, availablePageHeight);
			}

			var totalWidth:Number = positionX + tileSize + this._paddingRight;
			if(!isNaN(suggestedBounds.width))
			{
				if(this._paging == PAGING_VERTICAL)
				{
					totalWidth = suggestedBounds.width;
				}
				else if(this._paging == PAGING_HORIZONTAL)
				{
					totalWidth = Math.ceil(itemCount / perPage) * suggestedBounds.width;
				}
			}
			var totalHeight:Number = totalPageHeight;
			if(!isNaN(suggestedBounds.height) && this._paging == PAGING_VERTICAL)
			{
				totalHeight = Math.ceil(itemCount / perPage) * suggestedBounds.height;
			}
			resultDimensions.x = totalWidth;
			resultDimensions.y = totalHeight;

			if(this._paging == PAGING_NONE)
			{
				const availableWidth:Number = isNaN(suggestedBounds.width) ? totalWidth : suggestedBounds.width;
				const availableHeight:Number = isNaN(suggestedBounds.height) ? totalHeight : suggestedBounds.height;
				this.applyHorizontalAlign(items, 0, itemCount - 1, totalWidth, availableWidth);
				this.applyVerticalAlign(items, 0, itemCount - 1, totalHeight, availableHeight);
			}
			return resultDimensions;
		}

		/**
		 * @inheritDoc
		 */
		public function getMinimumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int
		{
			const tileSize:Number = Math.max(0, this._typicalItemWidth, this._typicalItemHeight);
			const verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._gap) / (tileSize + this._gap);
			if(this._paging != PAGING_NONE)
			{
				const horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._gap) / (tileSize + this._gap);
				const perPage:Number = horizontalTileCount * verticalTileCount;
				if(this._paging == PAGING_HORIZONTAL)
				{
					var pageIndex:int = scrollX / width;
				}
				else
				{
					pageIndex = scrollY / height;
				}
				return pageIndex * perPage;
			}
			var columnIndexOffset:int = 0;
			const totalColumnWidth:Number = Math.ceil(itemCount / verticalTileCount) * (tileSize + this._gap) - this._gap;
			if(totalColumnWidth < width)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileSize + this._gap));
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileSize + this._gap) / 2);
				}
			}
			const columnIndex:int = -columnIndexOffset + Math.floor((scrollX - this._paddingLeft + this._gap) / (tileSize + this._gap));
			return columnIndex * verticalTileCount;
		}

		/**
		 * @inheritDoc
		 */
		public function getMaximumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int
		{
			const tileSize:Number = Math.max(0, this._typicalItemWidth, this._typicalItemHeight);
			const verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._gap) / (tileSize + this._gap);
			if(this._paging != PAGING_NONE)
			{
				var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._gap) / (tileSize + this._gap);
				const perPage:Number = horizontalTileCount * verticalTileCount;
				if(this._paging == PAGING_HORIZONTAL)
				{
					var pageIndex:int = scrollX / width;
				}
				else
				{
					pageIndex = scrollY / height;
				}
				return (pageIndex + 2) * perPage;
			}
			horizontalTileCount = Math.ceil((width - this._paddingLeft + this._gap) / (tileSize + this._gap)) + 1;
			var columnIndexOffset:int = 0;
			const totalColumnWidth:Number = Math.ceil(itemCount / verticalTileCount) * (tileSize + this._gap) - this._gap;
			if(totalColumnWidth < width)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileSize + this._gap));
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileSize + this._gap) / 2);
				}
			}
			const columnIndex:int = -columnIndexOffset + Math.floor((scrollX - this._paddingLeft + this._gap) / (tileSize + this._gap));
			return columnIndex * verticalTileCount + verticalTileCount * horizontalTileCount;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForItemIndexAndBounds(index:int, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const tileSize:Number = Math.max(0, this._typicalItemWidth, this._typicalItemHeight);
			const verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._gap) / (tileSize + this._gap);
			if(this._paging != PAGING_NONE)
			{
				const horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._gap) / (tileSize + this._gap);
				const perPage:Number = horizontalTileCount * verticalTileCount;
				const pageIndex:int = index / perPage;
				if(this._paging == PAGING_HORIZONTAL)
				{
					result.x = pageIndex * width;
					result.y = 0;
				}
				else
				{
					result.x = 0;
					result.y = pageIndex * height;
				}
			}
			else
			{
				result.x = this._paddingLeft + ((tileSize + this._gap) * index / verticalTileCount) + (width - tileSize) / 2;
				result.y = 0;
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function applyHorizontalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemWidth:Number, availableWidth:Number):void
		{
			var horizontalAlignOffsetX:Number = 0;
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				horizontalAlignOffsetX = availableWidth - totalItemWidth;
			}
			else if(this._horizontalAlign != HORIZONTAL_ALIGN_LEFT)
			{
				//we're going to default to center if we encounter an
				//unknown value
				horizontalAlignOffsetX = (availableWidth - totalItemWidth) / 2;
			}
			if(horizontalAlignOffsetX != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					item.x += horizontalAlignOffsetX;
				}
			}
		}

		/**
		 * @private
		 */
		protected function applyVerticalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemHeight:Number, availableHeight:Number):void
		{
			var verticalAlignOffsetY:Number = 0;
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				verticalAlignOffsetY = availableHeight - totalItemHeight;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffsetY = (availableHeight - totalItemHeight) / 2;
			}
			if(verticalAlignOffsetY != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					item.y += verticalAlignOffsetY;
				}
			}
		}
	}
}
