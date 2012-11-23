package {
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.qihoo.themefactory.sjx.components.FocusSprite;
	import com.qihoo.themefactory.sjx.components.LoaderSprite;
	import com.qihoo.themefactory.sjx.components.ThemeView;
	import com.qihoo.themefactory.sjx.ctrl.ViewManager;
	import com.qihoo.themefactory.sjx.utils.Paramenets;
	import com.qihoo.themefactory.sjx.utils.Utils;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="24", width="311", height="519")]
	public class ThemePreview extends Sprite {

		// public static const WIDTH: int = 480;
		// public static const HEIGHT: int = 520;
		
		// public static const WIDTH: int = 211;
		// public static const HEIGHT: int = 352;
		
		public static const WIDTH: int = 311;
		public static const HEIGHT: int = 519;
		public var zoom: Number = 1;
		
		// url参数
		private var _param: Paramenets;
		
		private var _focusArea: Rectangle;
		private var _manager: ViewManager;
		private var _managerInitTimer: Timer;
		
		private var _lock: LoaderSprite;
		private var _focus: FocusSprite;
		
		public function ThemePreview() {
			Security.allowDomain('*');
			Security.loadPolicyFile("http://p0.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p1.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p2.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p3.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p4.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p5.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p6.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p7.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p8.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://p9.qhimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://10.16.15.45:8989/crossdomain.xml");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align  = StageAlign.TOP_LEFT;
			
			stage.addEventListener(Event.RESIZE, Init);
			Utils.loadPolicy([
				"http://p0.qhimg.com/crossdomain.xml",
				"http://p1.qhimg.com/crossdomain.xml",
				"http://p2.qhimg.com/crossdomain.xml",
				"http://p3.qhimg.com/crossdomain.xml",
				"http://p4.qhimg.com/crossdomain.xml",
				"http://p5.qhimg.com/crossdomain.xml",
				"http://p6.qhimg.com/crossdomain.xml",
				"http://p7.qhimg.com/crossdomain.xml",
				"http://p8.qhimg.com/crossdomain.xml",
				"http://p9.qhimg.com/crossdomain.xml",
				"http://10.16.15.45:8989/crossdomain.xml"
			], load);
			Init(null);
		}
		
		private function Init(evt: Event): void {
			if (!stage.stageWidth || !stage.stageHeight)
				return;
			stage.removeEventListener(Event.RESIZE, Init);
			
			_param = new Paramenets(root.loaderInfo.parameters);
			var metadata: String = ExternalInterface.call('QIHOO.widgets.PhonePreview.getMetaData', _param.flashBox);
			var data: String = ExternalInterface.call('QIHOO.widgets.PhonePreview.getInitData', _param.flashBox);
			_param.metadata = metadata;
			_param.data = data;
			
			var wz: Number = WIDTH / Utils._width, hz: Number = HEIGHT / Utils._height;
			zoom = wz < hz ? wz : hz;
			
			_lock = new LoaderSprite(_param.loadIcon);
			_lock.x = 0;
			_lock.y = 0;
			addChild(_lock);
			_lock.hide();
			init();
			/*
			// 测试用代码.
			this.addEventListener(MouseEvent.CLICK, function (evt: MouseEvent): void {
				jsSave();
			});
			*/
		}
		
		public function jsChange(key: String, src: String): void {
			_manager.setImage(key, src);
		}
		
		public function jsFocus(key: String = null, view: String = null): void {
			if (key)
				_focus.change(_manager.focus(key, view));
			else
				_focus.show = false;
		}
		
		/** 保存预览图. */
		public function jsSave(): void {
			if (_lock.visible)
				return;
			_lock.show();
			_lock.text = '生成预览图中...';
			upload();
		}
		
		private function findShowView(): ThemeView {
			for (var i: int = 0, n: int = this.numChildren; i < n; i ++) {
				if (this.getChildAt(i) is ThemeView) {
					return ThemeView(this.getChildAt(i));
				}
			}
			return null;
		}
		
		/** 调用php的api, 进行文件上传. */
		public function upload(): void {
			jsFocus();
			var currentView: ThemeView = findShowView();
			if (!currentView)
				return;
			var bitmapData: BitmapData = new BitmapData(Utils._width, Utils._height);
			bitmapData.draw(currentView,
				new Matrix(Utils._width / WIDTH, 0, 0, Utils._height / HEIGHT, 0, 0));
			
			var bytes: ByteArray = new JPGEncoder(75).encode(bitmapData);
			/*
			// 本地存储(测试用).
			var fr: FileReference = new FileReference();
			fr.save(bytes, 'preview.png');
			return;
			*/
			// 服务端存储.
			var request: URLRequest = new URLRequest(_param.path);
			request.method = URLRequestMethod.POST;
			request.contentType = 'application/octet-stream';
			// request.contentType = 'multipart/form-data';
			request.data = bytes;
			var loader: URLLoader = new URLLoader();
			// 设置相应数据格式.
			// loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, uploadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, uploadIoError);
			loader.load(request);
		}
		
		public function uploadComplete(evt: Event): void {
			if (evt.target.data) {
				ExternalInterface.call('QIHOO.widgets.PhonePreview.onSaveComplete', _param.flashBox, '上传成功!', evt.target.data);
			} else {
				ExternalInterface.call('QIHOO.widgets.PhonePreview.onSaveComplete', _param.flashBox, '上传失败! 请稍等候再试.');
			}
		}
		public function uploadIoError(evt: IOErrorEvent): void {
			ExternalInterface.call('QIHOO.widgets.PhonePreview.onSaveComplete', _param.flashBox, '服务器各屁了 >_<');
		}
		
		private function init(): void {
			doLoad();
			
			_focus = new FocusSprite();
			_focus.x = 0;
			_focus.y = 0;
			addChild(_focus);
			_focus.visible = false;
		}
		
		public function doLoad(): void {
			_lock.text = '加载图片中...';
			_lock.show();
		}
		
		public function doLoaded(): void {
			_lock.hide();
		}
		
		/** 对js端派发事件. */
		public function fire(v: String, k: String): void {
			ExternalInterface.call('QIHOO.widgets.PhonePreview.onPreviewFire', _param.flashBox, k, v);
			// 先不显示焦点变更.
			_focus.change(_manager.focus(k, v));
		}
		
		/** 加载初始化图片. */
		private function load(): void {
			_manager = new ViewManager(this, _param.metadata);
			/*
			// 方案一： 先装载图片再显示, 代码被注释掉了， 如果需要使用把注释内容开启.
			Utils.loadImages(_param.data, draw);
			_managerInitTimer = new Timer(500);
			_managerInitTimer.addEventListener(TimerEvent.TIMER, function (evt: TimerEvent): void {
				draw();
			});
			*/
			
			// 方案二： 先显示再装载图片.
			initComplete();
			var json: Object = JSON.decode(_param.data);
			for (var key: String in json)
				_manager.setImage(key, json[key]);
		}
		
		/** 进行界面初始化绘制. */
		/*
		private function draw(bitmapDatas: Object = null): void {
			if (bitmapDatas) {
				_manager.initImage = bitmapDatas;
			}
			if (_manager.imageLoaded) {
				_managerInitTimer.running && _managerInitTimer.stop();
				initComplete();
			} else {
				_managerInitTimer.reset();
				_managerInitTimer.start();
			}
		}
		*/
		
		private function initComplete(): void {
			_lock.hide();
			_manager.show(_param.view);
			// 设置某个项的焦点
			ExternalInterface.addCallback('itemFocus', jsFocus);
			// 设置某个项的图片
			ExternalInterface.addCallback('itemChange', jsChange);
			// 保存缩略图.
			ExternalInterface.addCallback('save', jsSave);
			var timer: Timer = new Timer(400, 1);
			timer.addEventListener(TimerEvent.TIMER, function (evt: TimerEvent): void {
				ExternalInterface.call('QIHOO.widgets.PhonePreview.onPreviewFlashInitComplete', _param.flashBox);
			});
			timer.start();
			
			/*
			// 测试代码
			var testTimer: Timer = new Timer(2000, 2);
			testTimer.addEventListener(TimerEvent.TIMER, function (evt: TimerEvent): void {
				if (testTimer.currentCount == 1) {
					jsChange('com_cooliris_media', 'http://www.baidu.com/img/baidu_sylogo1.gif');
				}
				else if (testTimer.currentCount == 2) {
					jsFocus('com_android_soundrecorder');
				}
			});
			testTimer.start();
			*/
		}
	}
}
