package com.qihoo.themefactory.sjx.components {
	import com.qihoo.themefactory.sjx.utils.Utils;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.player.GIFPlayer;

	public class LoaderSprite extends Sprite {
		
		private var _text: TextField;
		private var _gif: GIFPlayer;
		private var _gifLoaded: Boolean;
		private var _isPlay: Boolean;
		
		public function LoaderSprite(src: String) {
			var g: Graphics = this.graphics,
				tx: int = ThemePreview.WIDTH - 32 >> 1, ty: int = ThemePreview.HEIGHT - 32 >> 1;
			g.lineStyle(1, 0, 0);
			g.beginFill(0xDDDDDD, .4);
			g.drawRect(0, 0, ThemePreview.WIDTH, ThemePreview.HEIGHT);
			g.endFill();
			if (src) {
				_gif = new GIFPlayer(false);
				_gif.load(new URLRequest(src));
				_gif.x = tx;
				_gif.y = ty - 24;
				addChild(_gif);
				_gif.addEventListener(GIFPlayerEvent.COMPLETE, function (evt: GIFPlayerEvent): void {
					_gifLoaded = true;
					if (_isPlay)
						_gif.play();
				});
			}
			
			_text = new TextField();
			_text.mouseEnabled = false;
			_text.x = tx - 20;
			_text.y = ty + 12;
			addChild(_text);
		}
		
		public function show(): void {
			_gifLoaded && _gif.play();
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			this.visible = true;
			_isPlay = true;
		}
		
		public function hide(): void {
			_gifLoaded && _gif.stop();
			this.visible = false;
			_isPlay = false;
		}
		
		public function set text(txt: String): void {
			_text.text = txt;
			_text.setTextFormat(Utils.getFormat());
		}
	}
}