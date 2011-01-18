package hxcv.ds;

interface PxItr2<T, ImgT, This:PxItr2<T, ImgT, This>> implements PxItr<T, ImgT, This>
{
	/*
	 * Get the channel 1 value of the pixel pointing to.
	 */
	public function get1():T;
	
	/*
	 * Set the channel 1 value of the pixel pointing to.
	 */
	public function set1(val:T):Void;
}