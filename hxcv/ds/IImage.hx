package hxcv.ds;

interface IImage<T:Float>{
	public function get(x:Int, y:Int, channel:Int):T;
	public function getHex(x:Int, y:Int, ?alpha:Null<Int>):Int;
	public function set(x:Int, y:Int, channel:Int, val:T):Void;
	public function setHex(x:Int, y:Int, val:Int):Void;
	public function getPixels():Array<T>;
	public function setPixels(src:Array<T>):Void;
	public function lock():Void;
	public function unlock():Void;
	public function clone():IImage<T>;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var numOfChannels(default, null):Int;
	public function iterator():Iterator<T>;
}

interface IImage1 < T:Float > implements IImage<T> {
	
}

interface IImage3 < T:Float > implements IImage<T> {
	
}

interface IImage4 < T:Float > implements IImage<T> {
	
}

interface IImageGray < T:Float > implements IImage1<T> {
	public function getGray(x:Int, y:Int):T;
	public function setGray(x:Int, y:Int, val:T):Void;
}

interface IImageRGB < T:Float > implements IImage3<T> {
	public function getR(x:Int, y:Int):T;
	public function setR(x:Int, y:Int, val:T):Void;
	public function getG(x:Int, y:Int):T;
	public function setG(x:Int, y:Int, val:T):Void;
	public function getB(x:Int, y:Int):T;
	public function setB(x:Int, y:Int, val:T):Void;
}

interface IImageARGB < T:Float > implements IImage4<T> {
	public function getA(x:Int, y:Int):T;
	public function setA(x:Int, y:Int, val:T):Void;
	public function getR(x:Int, y:Int):T;
	public function setR(x:Int, y:Int, val:T):Void;
	public function getG(x:Int, y:Int):T;
	public function setG(x:Int, y:Int, val:T):Void;
	public function getB(x:Int, y:Int):T;
	public function setB(x:Int, y:Int, val:T):Void;
}