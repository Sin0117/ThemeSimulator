package com.qihoo.themefactory.sjx.modes {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/** 图片数据的原对象. */
	public class Image {
		
		private var _src: String;
		private var _data: BitmapData;
		private var _zData: BitmapData;
		// private var _zoom: Number;
		
		public function Image(data: BitmapData, src: String, z: Number) {
			_data = data;
			_src = src;
			// _zoom = z;
			
			// _zData = new BitmapData(_data.width * _zoom, _data.height * _zoom, true, 0x00000000);
			// _zData.draw(_data, new Matrix(_zoom, 0, 0, _zoom));
		}
		
		public function get src(): String {
			return _src;
		}
		public function get bitmapData(): BitmapData {
			return _data;
		}
		public function get bitmapWidth(): int {
			return _data.width;
		}
		public function get bitmapHeight(): int {
			return _data.height;
		}
		/*
		public function get zoomBitmapData(): BitmapData {
			return _zData;
		}
		public function get zoomBitmapWidth(): int {
			return _zData.width;
		}
		public function get zoomBitmapHeight(): int {
			return _zData.height;
		}
		*/
	}
}