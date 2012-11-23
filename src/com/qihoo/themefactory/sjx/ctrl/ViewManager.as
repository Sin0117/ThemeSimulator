package com.qihoo.themefactory.sjx.ctrl {
	import com.adobe.serialization.json.JSON;
	import com.qihoo.themefactory.sjx.components.ThemeView;
	import com.qihoo.themefactory.sjx.modes.Image;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class ViewManager {
		
		// 当前显示的视图.
		private var _view: String;
		private var _views: Object;
		
		private var _imageLoad: Boolean;
		
		private var _imageManager: ImageManager;
		private var _root: ThemePreview;
		
		private var _initImgNum: int;
		private var _initTimer: Timer;
		
		private var _keyVersion: Object;
		
		public function ViewManager(r: ThemePreview, data: String) {
			_root = r;
			_views = {};
			_keyVersion = {};
			var metadata: Object = JSON.decode(data);
			for (var view: String in metadata) {
				_views[view] = create(view, metadata[view]);
			}
			_imageManager = new ImageManager(r.zoom);
			// 延迟处理, 进行图片初始化.
			/*
			_initTimer = new Timer(200);
			_initTimer.addEventListener(TimerEvent.TIMER, function(evt: TimerEvent): void {
				if (!_initImgNum) {
					_initTimer.stop();
					_imageLoad = true;
				}
			});
			*/
		}
		
		private function create(v: String, data: Object): ThemeView {
			var themeView: ThemeView = new ThemeView(v, data, _root.zoom);
			return themeView;
		}
		
		/** 展现形式. */
		public function show(view: String): void {
			_view && hide(_view);
			_root.addChild(_views[view]);
			_view = view;
		}
		public function hide(view: String): void {
			if (_views[view].parent)
				_root.removeChild(_views[view]);
		}
		public function move(view: String): void {
			
		}
		public function fade(view: String): void {
			
		}
		
		/** 设置一个焦点项. */
		public function focus(key: String, view: String = null): Rectangle {
			if (!view)
				view = _view;
			if (!ThemeView(_views[view]).hasKey(key))
				view = findViewByKey(key);

			if (view && view != _view && view in _views) { 
				show(view);
			}
			return ThemeView(_views[_view]).getFocus(key);
		}
		
		/** 查找key对应的view。 */
		private function findViewByKey(key: String): String {
			for (var v: String in _views) {
				if (_views[v].hasKey(key))
					return v;
			}
			return null;
		}
		
		/** 设置图片. */
		public function setImage(key: String, src: String, data: BitmapData = null): void {
			_imageLoad = false;
			var time: uint = new Date().getTime();
			_keyVersion[key] = time;
			_root.doLoad();
			_imageManager.getImage(src, time, function (img: Image, curTime: uint): void {
				if (_keyVersion[key] == curTime)
					for (var v: String in _views)
						_views[v].setImage(key, src, img.bitmapData);
				_root.doLoaded();
				// _initImgNum --;
			}, data);
		}
		
		/** 初始化全部的默认图片. */
		/*
		public function set initImage(datas: Object): void {
			_initImgNum = 0;
			for (var key: String in datas) {
				_initImgNum ++;
				setImage(key, datas[key]['src'], datas[key]['data']);
			}
			_initTimer.start();
		}
		
		public function get imageLoaded(): Boolean {
			return _imageLoad;
		}
		*/
	}
}
