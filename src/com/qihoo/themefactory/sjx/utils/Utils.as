package com.qihoo.themefactory.sjx.utils {
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextFormat;

	public class Utils {
		
		// 分辨率(默认尺寸是480 * 800, 如果出现其他尺寸, 按照缩放比例重新进行计算.)
		public static var _width: int = 480;
		public static var _height: int = 800;
		// 行图标数
		public static var _row: int = 4;
		// 列图标数
		private static var col: int = 4;
		// dockbar上的图标数量
		private static var dockbarCol: int = 5;
		// 图表距顶距离
		public static var _appY: int = 128;
		// 文字区域高度
		public static var _label: int = 40;
		// dockbar上的图标区域(图标会在此区域中居中).
		public static var _dockbarSize: int = 96;
		// 桌面图标区域(图标会在此区域中居中).
		public static var _size: int = 120;
		// 获取图片内容的代理函数
		public static var proxy: String;
		// 是否支持预览对页面派发事件.
		public static var isFire: Boolean = false;
		
		private static var _initDataMap: Object;
		
		public function Utils() {}
		
		public static function getFormat(s: int = 12, c: uint = 0x333333, bold: Boolean = true, align: String = null): TextFormat {
			var format: TextFormat = new TextFormat('宋体', s, c);
			if (align)
				format.align = align;
			format.bold = bold;
			return format;
		}
		
		public static function set _dockbarCol(c: int): void {
			dockbarCol = c;
			_dockbarSize = Math.round(_width / c);
		}
		public static function get _dockbarCol(): int {
			return dockbarCol;
		}
		
		public static function set _col(c: int): void {
			col = c;
			_size = Math.round(_width / c);
		}
		public static function get _col(): int {
			return col;
		}
		
		
		
		/** 加载授权文件. */
		public static function loadPolicy(arr: Array, callback: Function): void {
			var policyCount: int = arr.length;
			for (var i: int = 0, n: String; n = arr[i]; i ++) { 
				var loader: URLLoader = new URLLoader()
				loader.addEventListener(Event.COMPLETE, loadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				loader.load(new URLRequest(n));
			}
			
			function loadComplete(): void {
				policyCount --;
				if (policyCount <= 0)
					callback();
			}
			
			function loadError(): void {
				policyCount --;
				if (policyCount <= 0)
					callback();
			}
		}
		
		/** 加载初始化的图片. */
		/*
		public static function loadImages(data: String, callback: Function): void {
			var json: Object = JSON.decode(data), count: int = 0;
			_initDataMap = {};
			for (var key: String in json) {
				count ++;
				
				var loader: Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				
				loader.load(new URLRequest(_cache(json[key])));
				loader.name = key;
				_initDataMap[key] = loader;
			}
			
			function loadComplete(evt: Event): void {
				var loader: Loader = Loader(evt.currentTarget.loader);
				_initDataMap[loader.name] = {
					src: json[loader.name],
					data: Bitmap(loader.content).bitmapData,
					status: 1
				}

				count --;
				if (count <= 0) {
					callback(_initDataMap);
				}
			}
			
			function loadError(evt: IOErrorEvent): void {
				var loader: Loader = Loader(evt.currentTarget.loader);
				_initDataMap[loader.name] = {
					src: json[loader.name],
					data: new BitmapData(1, 1),
					status: 0
				}
				count --;
				if (count <= 0)
					callback(_initDataMap);
			}
			
			// 图片缓存处理. 
			function _cache(url: String): String {
				// 如果有缓存处理, 就先清除掉.
				var cacheIndex: int = url.indexOf('QIHOO_D_CACHE='), d: uint = new Date().getTime();
				if (cacheIndex != -1) {
					var arr: Array = url.split('QIHOO_D_CACHE='), end: int = arr[1].indexOf('&');
					if (end != -1)
						arr[1] = arr[1].substring(end + 1);
					url = arr.join('');
				}
				return url + (url.indexOf('?') != -1 ? '&QIHOO_D_CACHE=' : '?QIHOO_D_CACHE=') + d;
			}
		}
		*/
	}
}
