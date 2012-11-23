package com.qihoo.themefactory.sjx.utils {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MyLoader extends URLLoader {
		
		public var name: String;
		public var src: String;
		
		public function MyLoader(request:URLRequest=null) {
			super(request);
		}
	}
}