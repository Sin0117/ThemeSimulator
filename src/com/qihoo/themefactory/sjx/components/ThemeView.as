package com.qihoo.themefactory.sjx.components {
	
	import com.qihoo.themefactory.sjx.events.ThemeItemEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/** 主题的不同视图. */
	public class ThemeView extends Sprite {
		
		// 如果是应用图标，深度排列位置.
		public static const APP_Z: int = 4;
		public static const APP_STATIC_Z: int = 6;
		// 当前焦点的key.
		private var _item: String;
		private var _items: Object;
		// 视图名称.
		private var _name: String;
		// 视图中app图标数量.
		private var _appsNum: int = 0;
		
		private var _backgroundKey: String;
		private var _foregroundKey: String;
		
		private var _backgroundWidth: Number;
		private var _backgroundHeight: Number;
		private var _foregroundWidth: Number;
		private var _foregroundHeight: Number;
		
		private var _backgroundArr: Array;
		private var _foregroundArr: Array;
		private var _sort: Array;
		
		private var _zoom: Number;
		
		public function ThemeView(v: String, data: Object, z: Number) {
			_name = v;
			_zoom = z;
			_items = {};
			_sort = [];
			_backgroundArr = [];
			_foregroundArr = [];
			for (var item: String in data) {
				_items[item] = create(item, data[item]);
			}
			if (_backgroundKey && _backgroundKey in data) {
				_backgroundWidth = data[_backgroundKey].width;
				_backgroundHeight = data[_backgroundKey].height;
			}
			if (_foregroundKey && _foregroundKey in data) {
				_foregroundWidth = data[_foregroundKey].width;
				_foregroundHeight = data[_foregroundKey].height;
			}
			
			sort();
		}
		
		/** 获取前后板的尺寸. */
		public function get foregroundWidth(): Number {
			return _foregroundWidth;
		}
		public function get foregroundHeight(): Number {
			return _foregroundHeight;
		}
		public function get backgroundWidth(): Number {
			return _backgroundWidth;
		}
		public function get backgroundHeight(): Number {
			return _backgroundHeight;
		}
		
		/** 检测该视图中是否存在这个项. */
		public function hasKey(key: String): Boolean {
			return key in _items;
		}
		
		/** 用户点击主题项时对外派发. */
		public function fire(key: String): void {
			_item = key;
			if (parent) {
				ThemePreview(parent).fire(_name, _item);
			}
		}
		
		/** 用户点击操作项时，对预览的事件派发. */
		public function getFocus(key: String): Rectangle {
			_item = key;
			return _items[_item].focus;
		}
		
		private function create(n: String, info: Object): ThemeItem {
			var themeItme: ThemeItem;
			if (info.z == APP_Z || info.z == APP_STATIC_Z) {
				if (info.rollable) {// 标准应用图标。
					themeItme = new ThemeItem(n, info, _zoom, _appsNum ++);
				} else if (info.index !== undefined) {
					themeItme = new ThemeItem(n, info, _zoom, -1, info.index);
				} else {
					themeItme = new ThemeItem(n, info, _zoom, _appsNum ++);
				}
				if ('background' in info) {
					_backgroundKey = info['background'];
					_backgroundArr.push(themeItme);
				}
				if ('foreground' in info) {
					_foregroundKey = info['foreground'];
					_foregroundArr.push(themeItme);
				}
			}
			else {
				themeItme = new ThemeItem(n, info, _zoom);
			}
			// 如果做滑屏，在这里加入类型判断。
			if (!_sort[info.z]) {
				_sort[info.z] = []
			}
			_sort[info.z].push(themeItme);
			addChild(themeItme);
			return themeItme;
		}
		
		/** 设置主题项的图片. */
		public function setImage(key: String, src: String, data: BitmapData): void {
			if (key == _backgroundKey) {
				setGround(_backgroundArr, 'background', data);
			}
			if (key == _foregroundKey) {
				setGround(_foregroundArr, 'foreground', data);
			}
			if (key in _items) {
				_items[key].setImage(src, data);
			}
		}
		
		public function setGround(arr: Array, type: String, data: BitmapData): void {
			var i: int, item: ThemeItem;
			for (i = 0; item = arr[i]; i ++) {
				item[type] = data;
			}
		}
		
		/** 深度排序. */
		public function sort(): void {
			var index: int = 0, i: int, j: int, n: int, tArr: Array, item: ThemeItem;
			for (i = 0, n = _sort.length; i < n; i ++) {
				tArr = _sort[i];
				if (tArr && tArr.length) {
					for (j = 0; item = tArr[j]; j ++) {
						setChildIndex(item, index++);
					}
				}
			}
		}
	}
}
