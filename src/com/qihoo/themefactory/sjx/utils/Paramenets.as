package com.qihoo.themefactory.sjx.utils {
	import flash.external.ExternalInterface;
	
	public class Paramenets {
			
		private var _path: String;
		private var _loadIcon: String;
		private var _metadata: String;
		private var _data: String;
		private var _view: String;
		private var _resolutionWidth: int;
		private var _resolutionHeight: int;
		
		private var _flashBox: String;
		
		public function Paramenets(p: Object) {
			_flashBox = p['box'] || 'ThemePreview';
			
			_path = p['path'];
			_loadIcon = p['loadicon'];
			_data = p['data'];
			_metadata = p['metadata'];
			_view = p['view'];
			if (p['appCol'])
				Utils._col = p['appCol'];
			if (p['appRow'])
				Utils._row = p['appRow'];
			if (p['appLabel'])
				Utils._label = p['appLabel'];
			if (p['appY'])
				Utils._appY = p['appY'];
			if (p['resolutionWidth'])
				Utils._width = p['resolutionWidth'];
			if (p['resolutionHeight'])
				Utils._height = p['resolutionHeight'];
			if (p['dockbarAppCol'])
				Utils._dockbarCol = p['dockbarAppCol'];
			if (p['fire'] && p['fire'] != 'false' && p['fire'] != '0')
				Utils.isFire = p['fire'];
		}
		
		public function get flashBox(): String {
			return _flashBox;
		}
		
		public function get path(): String {
			return this._path;
		}
		public function get loadIcon(): String {
			return this._loadIcon || '/ajax-loader.gif';
		}
		public function get view(): String {
			if (this._view)
				return this._view;
			return 'main';
		}
		public function set metadata(data: String): void {
			_metadata = data
		}
		public function get metadata(): String {
			if (this._metadata)
				return this._metadata;
			return '{"main":{' +
				'"status_bar":{"z":9,"x":0,"y":0,"widget":true,' +
					'"parent":"icon","width":480,"height":36},' +
				'"weather_widget":{"z":2,"x":1,"y":120,"widget":true,' +
					'"parent":"icon","width":479,"height":238},' +
				'"clear_screen":{"z":6,"x":0,"y":480,"widget":true,' +
					'"parent":"icon","width":86,"height":86,"label":"\u4e00\u952e\u6e05\u5c4f"},' +
				'"net_qihoo_launcher_theme":{"z":6,"x":120,"y":480,' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u6211\u7684\u4e3b\u9898"},' +
				'"com_android_camera":{"z":6,"x":240,"y":480,' +
					'"parent":"icon","width":86,"height":86,"label":"\u76f8\u673a"},' +
				'"com_cooliris_media":{"z":6,"x":360,"y":480,' +
					'"parent":"icon","width":86,"height":86,"label":"\u56fe\u5e93"},' +
				'"com_android_contacts2":{"index":0,"z":4,"y":704,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u7535\u8bdd"},' +
				'"com_android_mms":{"index":4,"z":4,"y":704,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u77ed\u4fe1"},' +
				'"icon_drawer":{"index":2,"y":704,"z":4,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u8fdb\u5165\u62bd\u5c49"},' +
				'"com_android_contacts":{"index":1,"y":704,"z":4,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u8054\u7cfb\u4eba"},' +
				'"com_android_browser":{"index":3,"y":704,"z":4,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u6d4f\u89c8\u5668"},' +
				'"workspace_bg":{"x":-240,"y":0,"z":0,"parent":"background","width":960,"height":800},' +
				'"workspace_dockbar_bg":{"x":0,"y":695,"z":1,"parent":"dockbar","width":480,"height":105},' +
				'"icon_bg":{"z":3,"y":-800,"parent":"dockbar","width":86,"height":86},' +
				'"workspace_indicator":{"arr":[{"x":160,"y":668,"z":2},{"x":192,"y":668,"z":2},{"x":256,"y":668,"z":2},{"x":288,"y":668,"z":2}],' +
					'"parent":"navigation","width":20,"height":20},' +
				'"workspace_indicator_current":{"x":224,"y":668,"z":2,"parent":"navigation","width":20,"height":20}},' +
				'"drawer":{' +
				'"status_bar":{"z":9,"x":0,"y":0,"widget":true,' +
					'"parent":"icon","width":480,"height":36},' +
				'"drawer_folder":{"z":2,"x":1,"y":36,"widget":true,' +
					'"parent":"icon","width":480,"height":68},' +
				'"com_android_settings":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u8bbe\u7f6e"},' +
				'"com_android_calendar":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u65e5\u5386"},' +
				'"com_android_deskclock":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u65f6\u949f"},' +
				'"com_android_calculator2":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u8ba1\u7b97\u5668"},' +
				'"com_android_music":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u97f3\u4e50"},' +
				'"com_google_android_apps_maps":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u5730\u56fe"},' +
				'"com_android_soundrecorder":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u5f55\u97f3\u673a"},' +
				'"com_android_email":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u7535\u5b50\u90ae\u4ef6"},' +
				'"com_android_vending":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"\u7535\u5b50\u5e02\u573a"},' +
				'"com_google_android_talk":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"Gtalk"},' +
				'"com_google_android_gm":{"z":4,"rollable":true,"background":"icon_bg","foreground":"",' +
					'"parent":"icon","width":86,"height":86,"v_width":72,"v_height":72,"label":"Gmail"},' +
				'"icon_home":{"index":2,"y":704,"z":4,"dockbar":true,"parent":"icon","width":76,"height":76,"label":"\u8fdb\u5165\u684c\u9762"},' +
				'"workspace_bg":{"x":-240,"y":0,"z":0,"parent":"background","width":960,"height":800,"mask":"0x000000","maskAlpha":0.6},' +
				'"workspace_dockbar_bg":{"x":0,"y":695,"z":1,"parent":"dockbar","width":480,"height":105},' +
				'"icon_bg":{"z":3,"y":-800,"parent":"dockbar","width":86,"height":86},' +
				'"workspace_indicator":{"arr":[{"x":160,"y":668,"z":2},{"x":192,"y":668,"z":2},{"x":256,"y":668,"z":2},{"x":288,"y":668,"z":2}],' +
					'"parent":"navigation","width":20,"height":20},' +
				'"workspace_indicator_current":{"x":224,"y":668,"z":2,"parent":"navigation","width":20,"height":20}}}';
		}
		public function set data(data: String): void {
			_data = data
		}
		public function get data(): String {
			if (this._data)
				return this._data;
			return '{' +
				'"status_bar":"http://p2.qhimg.com/t01e34730d2f2f6a5be.png",' +
				'"drawer_folder":"http://p7.qhimg.com/t01022552ead1294c26.png",' +
				'"weather_widget":"http:\/\/p9.qhimg.com\/t0133504cd478199f10.png",' +
				'"clear_screen":"http:\/\/p7.qhimg.com\/t014c4e482deb292d21.png",' +
				'"workspace_bg":"http:\/\/p9.qhimg.com\/t01e18fb1aa7f672ddb.jpg",' +
				'"workspace_dockbar_bg":"http:\/\/p1.qhimg.com\/t014c258025a4d2c38b.png",' +
				'"icon_bg":"http:\/\/p2.qhimg.com\/t019e939a5e2590faff.png",' +
				'"workspace_indicator":"http:\/\/p1.qhimg.com\/t0110ee657f91aa1a06.png",' +
				'"workspace_indicator_current":"http:\/\/p0.qhimg.com\/t0113445b17f91a9f71.png",' +
				'"com_android_contacts2":"http:\/\/p2.qhimg.com\/t01acc94811a13ac6ee.png",' +
				'"com_android_mms":"http:\/\/p9.qhimg.com\/t010368850ec58dac08.png",' +
				'"com_android_contacts":"http:\/\/p9.qhimg.com\/t018904aa7666bce412.png",' +
				'"com_android_browser":"http:\/\/p1.qhimg.com\/t0194df6175ae11ba0d.png",' +
				'"net_qihoo_launcher_theme":"http:\/\/p1.qhimg.com\/t015ed97b118bd22134.png",' +
				'"com_android_settings":"http:\/\/p0.qhimg.com\/t01c01b89f7f4edb0b5.png",' +
				'"com_android_calendar":"http:\/\/p6.qhimg.com\/t01a09733d415e4c2a7.png",' +
				'"com_android_deskclock":"http:\/\/p4.qhimg.com\/t0112854160067bd121.png",' +
				'"com_cooliris_media":"http:\/\/p0.qhimg.com\/t011b35c333b6cff93b.png",' +
				'"com_android_calculator2":"http:\/\/p4.qhimg.com\/t01858a6fa4923d9848.png",' +
				'"com_android_music":"http:\/\/p7.qhimg.com\/t013d63c3f7c3fe260d.png",' +
				'"com_android_camera":"http:\/\/p2.qhimg.com\/t015fe6920fd9861efc.png",' +
				'"com_google_android_apps_maps":"http:\/\/p7.qhimg.com\/t01633e4225d39486fb.png",' +
				'"com_android_soundrecorder":"http:\/\/p9.qhimg.com\/t01f041747ea02eda21.png",' +
				'"com_android_email":"http:\/\/p9.qhimg.com\/t0141d4e3d6fe355e7a.png",' +
				'"com_android_vending":"http:\/\/p0.qhimg.com\/t017ba89d9cb0f1682c.png",' +
				'"com_google_android_talk":"http:\/\/p5.qhimg.com\/t0155833314d846eee5.png",' +
				'"com_google_android_gm":"http:\/\/p3.qhimg.com\/t018273c79c5fa2d032.png",' +
				'"icon_drawer":"http:\/\/p8.qhimg.com\/t01c00fbe84343ebbb4.png",' +
				'"icon_home":"http:\/\/p2.qhimg.com\/t01d76fc8fe9b081265.png"}';
		}
	}
}
