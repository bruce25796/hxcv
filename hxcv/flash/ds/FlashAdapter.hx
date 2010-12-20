package hxcv.flash.ds;

import flash.display.DisplayObject;
import flash.geom.Point;
import flash.Vector;
import hxcv.ds.ArrayAccessPixelIterator;

class Vector2Adapter 
{
	inline static public function getPositionVector2(dObj:DisplayObject) {
		return new PositionVector2(dObj);
	}
	
	inline static public function getVector2(dObj:Point) {
		return new PointVector2(dObj);
	}
}

class VectorAdapter
{
	inline static public function getPixelIterator<T>
	(
		array:Vector<T>,
		imageWidth:Int, 
		imageHeight:Int, 
		imageNumOfChannels:Int
	):VectorPixelIterator<T> 
	{
		return 
			new VectorPixelIterator<T>()
				.init(
					array,
					imageWidth, 
					imageHeight, 
					imageNumOfChannels
				);
	}
}

typedef ArrayAdapter = hxcv.ds.Adapters.ArrayAdapter;