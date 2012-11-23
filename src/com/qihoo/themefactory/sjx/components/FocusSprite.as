package com.qihoo.themefactory.sjx.components {
	
	import com.qihoo.themefactory.sjx.utils.Utils;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class FocusSprite extends Sprite {
		
		private var _g: Graphics;
		private var _timer: Timer;
		private var _show: Boolean;
		
		private var _speedX: int;
		private var _speedY: int;
		private var _distanceX: int;
		private var _distanceY: int;
		
		public function FocusSprite() {
			_g = graphics;
			
			_timer = new Timer(20, 1);
			_timer.addEventListener(TimerEvent.TIMER, function (evt: TimerEvent) : void {
				this.visible = _show;
				parent.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				parent.removeEventListener(MouseEvent.MOUSE_OUT, doMouseUp);
				parent.removeEventListener(MouseEvent.MOUSE_OVER, doMouseUp);
			});
			
			if (Utils.isFire) {
				// flash对页面的回调.
				this.addEventListener(Event.ADDED, function (evt: Event): void {
					parent.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
					addEventListener(Event.ENTER_FRAME, doEnterFrame);
				});
			}
		}
		
		private function doEnterFrame(evt: Event): void {
			
		}
		
		public function change(rect: Rectangle): void {
			_g.clear();
			_g.lineStyle(2, 0xf8ad1c, .7);
			_g.beginFill(0x777777, .2);
			_g.drawRect(rect.x, rect.y, rect.width - .4, rect.height - .4);
			_g.endFill();
			show = true;
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		public function set show(v: Boolean): void {
			visible = _show = v;
		}
		
		private function doMouseDown(evt: MouseEvent): void {
			this.visible = false;
			parent.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			parent.addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			parent.addEventListener(MouseEvent.MOUSE_OUT, doMouseUp);
			// dispatchEvent(evt);
		}
		
		private function doMouseOver(evt: MouseEvent): void {
			_timer.stop();
		}
		private function doMouseUp(evt: MouseEvent): void {
			_timer.reset();
			_timer.start();
		}
	}
}