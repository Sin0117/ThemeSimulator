package com.qihoo.themefactory.sjx.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ThemeItemEvent extends Event {
		public static const CLICK: String = 'theme-itme-click';
		
		public var key: String;
		public var view: String;
		
		public function ThemeItemEvent(k: String) {
			super(MouseEvent.CLICK);
			key = k;
		}
	}
}