package com.qihoo.themefactory.sjx.components {
	
	import com.qihoo.themefactory.sjx.utils.Utils;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import mx.utils.NameUtil;
	
	/** 主题的图片项. */
	public class ThemeItem extends Sprite {
		
		// 焦点的缩小偏移值.
		public static const FOCUS_OFFSET: int = 1;
		// 文字正常情况下尺寸
		public static const FONT_DEF_SIZE: int = 20;
		// 文字最小尺寸.
		public static const FONT_MIN_SIZE: int = 12;
		
		// 缩放前的尺寸
		private var _oWidth: int;
		private var _oHeight: int;
		private var _oX: int;
		private var _oY: int;
		// 缩放比例
		private var _zoom: Number;
		// 缩放后的尺寸
		private var _width: Number;
		private var _height: Number;
		private var _x: Number;
		private var _y: Number;
		// 排列位置.
		private var _z: int;
		
		// 整个项的视图尺寸
		private var _view: Rectangle;
		
		private var _icons: Array;
		private var _label: TextField;
		private var _background: Shape;
		private var _foreground: Shape;
		
		private var _img: BitmapData;
		private var _focus: Rectangle;
		
		// 应用图标的下标.
		private var _index: int;
		private var _dockbarIndex: int;
		// 当前图片的路径.
		private var _src: String;
		// 当前的图片数据.
		private var _data: Object;
		public var key: String;
		
		public function ThemeItem(k: String, data: Object, z: Number, idx: int = -1, dockIdx: int = -1) {
			_icons = [];
			
			key = k;
			_zoom = z;
			_data = data;
			_width = (_oWidth = data.v_width || data.width) * _zoom;
			_height = (_oHeight = data.v_height || data.height) * _zoom;
			_index = idx;
			_dockbarIndex = dockIdx;
			
			if (Utils.isFire && !_data['widget']) {
				// 主题项被点击后的事件派发.
				addEventListener(MouseEvent.MOUSE_UP, function (evt: MouseEvent): void {
					ThemeView(parent).fire(key);
				});
			}
			
			var pos: Array = data['arr'], i: int, n: Object;
			if (!pos) {
				pos = [{x: 0, y: 0}];
				_x = (_oX = data.x || 0) * _zoom;
				_y = (_oY = data.y || 0) * _zoom;
				_z = data['z'];
			} else {
				var minX: int = pos[0].x, minY: int = pos[0].y;
				_z = pos[0].z;
				for (i = 1; n = pos[i]; i ++) {
					if (minX > n.x)
						minX = n.x;
					if (minY > n.y)
						minY = n.y;
				}
				
				for (i = 0; n = pos[i]; i ++) {
					n.x -= minX;
					n.y -= minY;
				}
				_x = (_oX = minX) * _zoom;
				_y = (_oY = minY) * _zoom;
			}

			var viewWidth: Number = Utils._size * _zoom,
				viewHeight: Number = (Utils._size + Utils._label - 20) * _zoom;
			for (i = 0; n = pos[i]; i ++) {
				var icon: Shape = new Shape();
				addChild(icon);
				_icons.push(icon);
				if (_index != -1) { // 应用图标
					icon.x = (viewWidth - _width) * .5;
					icon.y = (viewWidth - _height) * .5;
					if (data['label']) {
						var effect: DropShadowFilter = new DropShadowFilter(2, 75, 0, .9, 4, 4),
							fontSize: int = FONT_DEF_SIZE * _zoom;
						_label = new TextField();
						_label.text = data['label'];
						_label.setTextFormat(Utils.getFormat(FONT_MIN_SIZE > fontSize ? FONT_MIN_SIZE : fontSize, 0xFFFFFF, false, TextFormatAlign.CENTER));
						_label.width = _data.width * _zoom;
						_label.height = Utils._label * _zoom;
						_label.y = (Utils._size - 20) * _zoom;
						_label.x = (viewWidth - _label.width) * .5;
						_label.mouseEnabled = false;
						_label.filters = [effect];
						addChild(_label);
					}
					if (!_data.rollable) {
						this.x = _x;
						this.y = _y;
					} else {
						this.x = viewWidth * (_index % Utils._col);
						this.y = (Utils._appY + (Utils._size + Utils._label - 20) * (_index / Utils._col >> 0)) * _zoom;
					}
					_background = new Shape();
					addChildAt(_background, 0);
					_foreground = new Shape();
					addChild(_foreground);
				} else { // 其他.
					if (_dockbarIndex != -1) {
						viewHeight = viewWidth = Utils._dockbarSize * _zoom;
						icon.x = (viewWidth - _width) * .5;
						icon.y = (viewHeight - _height) * .5;
						this.x = _dockbarIndex % Utils._dockbarCol * viewWidth;
						this.y = _y;
					} else {
						icon.x = n.x * _zoom;
						icon.y = n.y * _zoom;
						this.x = _x;
					}
					this.y = _y;
				}
			}
			if (_index != -1) {
				_view = new Rectangle(FOCUS_OFFSET * .5, FOCUS_OFFSET * .5, viewWidth - FOCUS_OFFSET, viewHeight - FOCUS_OFFSET);
			} else {
				// dockbar上的图标.
				if (_dockbarIndex != -1) {
					_view = new Rectangle((viewWidth - _width) * .5, 
							(viewHeight - _height) * .5, 
							_width - FOCUS_OFFSET, 
							_height - FOCUS_OFFSET);
				} else {
					_view = new Rectangle((this.x < 0 ? -this.x : 0) + FOCUS_OFFSET * .5, 
							(this.y < 0 ? -this.y : 0) + FOCUS_OFFSET * .5,
							(_width > ThemePreview.WIDTH ? ThemePreview.WIDTH : _width) - FOCUS_OFFSET,
							(_height > ThemePreview.HEIGHT ? ThemePreview.HEIGHT : _height) - FOCUS_OFFSET);
				}
			}
			if (key == 'icon_bg') {
				_focus = new Rectangle(0, 0, 0, 0);
			} else {
				_focus = new Rectangle(this.x + _view.x, this.y + _view.y, _view.width, _view.height);
			}
		}
		
		public function get focus(): Rectangle {
			return _focus;
		}
		/** 计算显示控件位置。 */
		private function getX(): Number {
			return 0;
		}
		private function getY(): Number {
			return 0;
		}
		/** 计算显示控件尺寸。 */
		private function getW(): Number {
			return 0;
		}
		private function getH(): Number {
			return 0;
		}
		
		/** 绘制. */
		private function draw(): void {
			var zx: Number = _width / _img.width, zy: Number = _height / _img.height;
			for (var i: int = 0, n: Shape; n = _icons[i]; i ++) {
				var g: Graphics = n.graphics;
				g.clear();
				g.beginBitmapFill(_img, new Matrix(zx, 0, 0, zy, 0, 0), false, true);
				g.drawRect(0, 0, _width, _height);
				/*
				// 如果有widget的处理.
				if (_data['widget']) {
					g.beginBitmapFill(new Widget().bitmapData, new Matrix(_zoom, 0, 0, _zoom, 240 * _zoom, 128 * _zoom), false, true);
					g.drawRect(240 * _zoom, 120 * _zoom, 479 * _zoom, 238 * _zoom);
				}
				*/
				
				// 如果是需要蒙板的处理.
				if (_data['mask']) {
					g.beginFill(parseInt(_data['mask']), _data['maskAlpha'] || .4);
					g.drawRect(0, 0, _width, _height);
				}
				g.endFill();
			}
		}
		
		/** 设置前后板. */
		public function set background(data: BitmapData): void {
			drawGround(_background.graphics, ThemeView(this.parent).backgroundWidth, ThemeView(this.parent).backgroundHeight, data);
		}
		public function set foreground(data: BitmapData): void {
			drawGround(_foreground.graphics, ThemeView(this.parent).foregroundWidth, ThemeView(this.parent).foregroundHeight, data);
		}
		private function drawGround(g: Graphics, w: Number, h: Number, data: BitmapData): void {
			var x: Number = (Utils._size - w) * _zoom + 2 >> 1,
				y: Number = (Utils._size - h) * _zoom + 1>> 1,
				dw: Number = w * _zoom, dh: Number = h * _zoom;
			g.clear();
			g.beginBitmapFill(data, new Matrix(dw / data.width, 0, 0, dh / data.height, x, y), false, true);
			g.drawRect(x, y, dw, dh);
			g.endFill();
		}
		
		/** 设置图片. */
		public function setImage(src: String, data: BitmapData): void {
			_img = data;
			_src = src;
			draw();
		}
	}
}