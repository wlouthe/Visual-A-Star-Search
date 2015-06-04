package com {
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import com.myPos;
	import flash.geom.Point;
	import flash.display.Shape;
	
	public class main extends MovieClip {

		var myBitMap:BitmapData;
		var startPosX:Number;
		var startPosY:Number;
		var endPosX:Number;
		var endPosY:Number;
		var open:Vector.<myPos>;
		var closed:Vector.<myPos>;
		var working:Vector.<myPos>;
		var pathFound:Boolean;
		var currentPos:myPos;
		
		public function main() {
			// constructor code
			drawPath();
		}
		
		public function drawPath()
		{
			myBitMap = new BitmapData(stage.width, stage.height);
			myBitMap.draw(stage);
			findPath(startPosX,startPosY);
		}
		public function findPath(myX:Number, myY:Number)
		{
			
			//every open/working node should have an associated parallel G value with them, so if a lower g value is found the
			// new value can be added to working at the reduced cost.
			
			// perhaps there should be a parallel radix sort for the 2 parallel vectors so that you can always see which move is best next
			
			//possibly consider linked list to store the current path.
			//each linked list has a corresponding value, 
			/*
			var myVec:Vector.<myPos> = new Vector.<myPos>();
			myVec.push(new myPos(6,7,8,9));
			myVec.push(new myPos(5,6,7,8));
			myVec.push(new myPos(4,5,6,7));
			myVec.push(new myPos(3,4,5,6));
			myVec.push(new myPos(2,3,4,5));
			myVec.push(new myPos(1,2,3,4));
			for each(var x in myVec)
			{
				trace(x.f);
			}
			myVec=radixSort(myVec,0);
			//myVec.pop();
			for each(var k in myVec)
			{
				trace(k.f);
			}
			//*/
			startPosX = 0;
			startPosY = 0;
			endPosX = stage.width-1;
			endPosY = stage.height-1;
			open = new Vector.<myPos>();
			closed = new Vector.<myPos>();
			pathFound = false;
			open.push(new myPos(startPosX,startPosY, 0, (Math.abs(endPosX - startPosX) + Math.abs(endPosY - startPosY))*10));
			//var rgb1:uint = myBitMap.getPixel(5,5);
			//trace(rgb1 & 0xffffff)
			//trace(rgb1>>16);
			//trace(rgb1>>8 & 0xff);
			//trace (rgb1 & 0xff);
			while(!pathFound)
			{
				//trace("hello");
				open = radixSortF(open,0);
				//trace(open);
				currentPos = open[0]
				//trace("its me");
				closed.push(open.shift());
				//trace("chun lee");
				findAdjacent(currentPos);
				//pathFound = true;
			}
			trace("path has been found");
			open = radixSortF(open, 0);
			open = radixSortH(open, 0);
			var path:Shape = new Shape();
			//path.beginFill(0xFF0000);
			path.graphics.lineStyle(4, 0xFF0000);
			currentPos = open[0];
			trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
			path.graphics.moveTo(currentPos.x,currentPos.y);
			while(currentPos.x != 0 && currentPos.y !=0)
			{
				for each(var test in closed)
				{
					if(test.x == currentPos.lastX && test.y == currentPos.lastY)
					{
						currentPos = test;
						trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
						path.graphics.lineTo(currentPos.x, currentPos.y);
						break;
					}
				}
				trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
				path.graphics.lineTo(currentPos.x, currentPos.y);
			}
			stage.addChild(path);
			
			/*
			var rgb:uint = myBitMap.getPixel(myX,myY);
			if((rgb & 0xffffff) != 0x000000)
			{
				
			}
			//*/
		}
		public function radixSortF(myList:Vector.<myPos>, i:Number):Vector.<myPos>
		{
			if(i == 4) return myList;
			
			var j:Number;
			var tempList:Vector.<myPos> = new Vector.<myPos>(myList.length);
			var count:Vector.<Number> = new Vector.<Number>(256);
			var map:Vector.<Number> = new Vector.<Number>(256);
			//count:Vector.<Number>;
			//for(i:Number = 0; i<4; i++)
			//trace (myList.length);
			{
				for each (var x in myList)
				{
					count[(x.f >> (0xff*i)) & 0xff]++;
					//trace(count);
				}
				for(j = 1; j < 256; j++)
				{
					map[j] = map[j-1]+count[j-1];
				}
				for (j = 0; j<myList.length; j++)
				{
					tempList[map[(myList[j].f >> (0xff*i)) & 0xff]++] = myList[j];
				}
			}
			
			return radixSortF(tempList, ++i);
		}
		public function radixSortH(myList:Vector.<myPos>, i:Number):Vector.<myPos>
		{
			if(i == 4) return myList;
			
			var j:Number;
			var tempList:Vector.<myPos> = new Vector.<myPos>(myList.length);
			var count:Vector.<Number> = new Vector.<Number>(256);
			var map:Vector.<Number> = new Vector.<Number>(256);
			//count:Vector.<Number>;
			//for(i:Number = 0; i<4; i++)
			//trace (myList.length);
			{
				for each (var x in myList)
				{
					count[(x.h >> (0xff*i)) & 0xff]++;
					//trace(count);
				}
				for(j = 1; j < 256; j++)
				{
					map[j] = map[j-1]+count[j-1];
				}
				for (j = 0; j<myList.length; j++)
				{
					tempList[map[(myList[j].h >> (0xff*i)) & 0xff]++] = myList[j];
				}
			}
			
			return radixSortH(tempList, ++i);
		}
		public function radixSortG(myList:Vector.<myPos>, i:Number):Vector.<myPos>
		{
			if(i == 4) return myList;
			
			var j:Number;
			var tempList:Vector.<myPos> = new Vector.<myPos>(myList.length);
			var count:Vector.<Number> = new Vector.<Number>(256);
			var map:Vector.<Number> = new Vector.<Number>(256);
			//count:Vector.<Number>;
			//for(i:Number = 0; i<4; i++)
			//trace (myList.length);
			{
				for each (var x in myList)
				{
					count[(x.h >> (0xff*i)) & 0xff]++;
					//trace(count);
				}
				for(j = 1; j < 256; j++)
				{
					map[j] = map[j-1]+count[j-1];
				}
				for (j = 0; j<myList.length; j++)
				{
					tempList[map[(myList[j].h >> (0xff*i)) & 0xff]++] = myList[j];
				}
			}
			
			return radixSortG(tempList, ++i);
		}
		public function findAdjacent(myPoint:myPos)
		{
			//trace(stage.width);
			//trace(stage.height);
			var myG:Number;
			var openTest:Boolean;
			if (myPoint.x+1 == endPosX || myPoint.x-1 == endPosX || myPoint.x == endPosX)
			{
				if(myPoint.y+1 == endPosY || myPoint.y-1 == endPosY || myPoint.y == endPosY)
				{
					trace("path found");
					pathFound = true;
				}
			}
			for(var i:Number = -1; i<=1; i++)
			{
				for(var j:Number =-1; j<=1;j++)
				{
					
					myG = 10;
					openTest = false;
					if (i==0 && j==0) continue;
					if(myPoint.x+i >= 0 && myPoint.x+i <= stage.width && myPoint.y+j >= 0 && myPoint.y+j <= stage.height)
					{
						if(i!=0 && j!=0) myG = 14;
						var rgb:uint = myBitMap.getPixel(myPoint.x+i,myPoint.y+j);
						if((rgb & 0xffffff) != 0xffffff)
						{
							//trace("x:"+(myPoint.x+i) +"; y:" + (myPoint.y+j));
							continue;
						}
						for each(var test in open)
						{
							if(test.x == myPoint.x+i && test.y == myPoint.y+j)
							{
								if(test.g >= myPoint.g + myG)
								{
									test.g = myPoint.g + myG;
									test.f = test.g+test.h;
									test.lastX = myPoint.x;
									test.lastY = myPoint.y;
								}
								openTest = true;
							}
						}
						if(openTest == false)
						{
							for each (var ctest in closed)
							{
								if(ctest.x == myPoint.x+i && ctest.y == myPoint.y+j)
								{
									openTest = true;
								}
							}
						}
						if(openTest == false)
						{
							//var myH:Number = Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j));
							//for(var toSplice:Number = 0; toSplice<open.length; toSplice++)
							//{
							//	if(open[toSplice].f >= myH + myPoint.g+myG)
							//	{
							//		trace("adding pos x: "+myPoint.x+i);
							//		open.splice(toSplice, 0,new myPos(myPoint.x+i,myPoint.y+j,myPoint.g+myG, myH));
							//		break;
							//	}
							//}
							open.push(new myPos(myPoint.x+i,myPoint.y+j,myPoint.g+myG, (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10));
							open[open.length-1].lastX = myPoint.x;
							open[open.length-1].lastY = myPoint.y;
						}
					}
				}
			}
			//if(myPoint.x+1>0 && myPoint.x+1 < stage.width)
			//{
			//	
			//}
		}
	}
	
}
