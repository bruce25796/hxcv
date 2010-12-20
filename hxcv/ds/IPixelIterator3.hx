package hxcv.ds;

interface IPixelIterator3<T, ImgT, This:IPixelIterator3<T, ImgT, This>> implements IPixelIterator2<T, ImgT, This>
{
	/*
	 * Get the channel 2 value of the pixel pointing to.
	 */
	public function get2():T;
	
	/*
	 * Set the channel 2 value of the pixel pointing to.
	 */
	public function set2(val:T):Void;
}