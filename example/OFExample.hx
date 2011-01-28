﻿package ;

import cpp.io.File;
import cpp.Lib;
import haxe.Timer;
using Lambda;
using org.casalib.util.NumberUtil;

import hxcv.BlockMatching;
import hxcv.MotionEstimation;
//import hxcv.ProximityManager;
import hxcv.ds.ArrayPxPtrGray;
import hxcv.ds.ArrayPxPtrARGB;
import hxcv.ds.ArrayPxPtr;
using hxcv.math.Vector2Math;
using hxcv.ds.Adapters;

import of.Context;
using of.Context.Functions;

class OFExample extends BaseApp {
	var me:MotionEstimation<ArrayPxPtrGray<Int>>;
	var originalFrames:Array<Image>;
	var mvFrames:Array<Image>;
	var motionVectors:Array<ArrayPxPtr<Float>>;
	var smoothedFrames:Array<Image>;
	var originalFramesGray:Array<ArrayPxPtrGray<Int>>;
	var mvImage:Image;
	
	var currentIndex:Int;
	var showMV:Bool;
	
	override function setup():Void {		
		enableSmoothing();
		setFrameRate(12);
		
		me = new MotionEstimation<ArrayPxPtrGray<Int>>().init(25);
		me.blockMatching.init(35,1,20,0.015);
		
		originalFrames = [];
		mvFrames = [];
		motionVectors = [];
		smoothedFrames = [];
		originalFramesGray = [];
		
		for (imgNum in 1050587...1050700) {
			var img = new Image();
			img.loadImage("D:/stopmotion/04/original-320-240/P" + imgNum + ".jpg");
			originalFrames.push(img);
			
			var mvStr = File.getContent("D:/stopmotion/04/original-320-240/P" + imgNum + ".txt");
			var mv = [].getPxPtr(320, 240, 2);
			var mvFrame = new Image();
			mvFrame.allocate(320, 240, Constants.OF_IMAGE_COLOR);
			var mvFramePP = mvFrame.getPixels().getPxPtrRGB(320, 240);
			
			var lines = [];
			for (line in mvStr.split("\n")) {
				lines.push(line.split("\t"));
			}
			
			for (i in 0...240) {
				for (x in 0...360) {
					mv.set(0, Std.parseFloat(lines[i][x]));
					mv.set(1, Std.parseFloat(lines[i + 240][x]));
					mv.unsafeNext();
					
					mvFramePP.set(0,cast Std.parseFloat(lines[i][x]));
					mvFramePP.set(1,cast Std.parseFloat(lines[i + 240][x]));
					mvFramePP.unsafeNext();
				}
			}
			mv.head();
			
			mvFrame.update();
			mvFrames.push(mvFrame);
			
			motionVectors.push(mv);
			
			var imgGray = new Image();
			imgGray.clone(img);
			imgGray.setImageType(Constants.OF_IMAGE_GRAYSCALE);
			originalFramesGray.push(cast imgGray.getPixels().getPxPtrGray(imgGray.width, imgGray.height));
		}
		
		currentIndex = 0;
		showMV = false;
		mvImage = new Image();
		var resultSize = me.getResultImageSize(originalFramesGray);
		mvImage.allocate(resultSize.val0, resultSize.val1, Constants.OF_IMAGE_COLOR_ALPHA);
	}
	
	override function draw():Void {
		setHexColor(0xFFFFFF);
		var currentFrame = originalFrames[currentIndex];
		currentFrame.draw(0, 0, 320, 240);
		
		currentFrame = mvFrames[currentIndex];
		currentFrame.draw(320, 0, 320, 240);

		if (showMV && currentIndex != originalFrames.length-1) {
			
			setHexColor(0xFF0000);
			var t = Timer.stamp();
			var mv = me.process([originalFramesGray[currentIndex], originalFramesGray[currentIndex + 1]])[0];
			trace(Timer.stamp() - t);
			
			
			var mvImagePI = mvImage.getPixels().getPxPtrARGB(mv.width, mv.height);
			mv.head();
			do {
				var x = me.N * 0.5 + mv.x * me.N;
				var y = me.N * 0.5 + mv.y * me.N;
				
				var v = mv.get0();
				line(x, y, x + v.val0, y + v.val1);
				
				mvImagePI.set0(cast v.val2 * 10000);
				mvImagePI.set1(cast v.val0.map( -me.blockMatching.S, me.blockMatching.S, 0, 255));
				mvImagePI.set2(cast v.val1.map( -me.blockMatching.S, me.blockMatching.S, 0, 255));
				mvImagePI.set3(cast 0xFF);
				mvImagePI.unsafeNext();
			} while (mv.next());
			mvImage.update();
			
			setHexColor(0xFFFFFF);
			mvImage.draw(320, 0, 320, 240);
			mvImage.saveImage("original-1024-768 "+currentIndex + ".png");
		}
		
		currentIndex = (++currentIndex).loopIndex(originalFrames.length);
	}
	
	override function keyPressed(key:Int):Void {
		switch(key) {
			case 'm'.charCodeAt(0):
				showMV = !showMV;
		}
	}
	
	static function main():Void {
		AppRunner.setupOpenGL(new AppGlutWindow(), 800, 600, Constants.OF_WINDOW);
		AppRunner.runApp(new OFExample());
	}
}