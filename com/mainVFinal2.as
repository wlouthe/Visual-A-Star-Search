package com {
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import com.myPos;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
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
		var pos:Array;
		var drawGrid:drawing;
		var path:Shape;
		
		public function main() {
			// constructor code
			drawGrid = new drawing(stage.width,stage.height);
			addEventListener(MouseEvent.MOUSE_DOWN, mousePush,false,0,true);
			addChild(drawGrid);
			path = new Shape();
			stage.addChild(path);
			//addEventListener(MouseEvent.MOUSE_UP, mouseRelease,false,0,true);
		}
		
		public function mousePush(m:MouseEvent)
		{
			trace("MouseDown");
			removeEventListener(MouseEvent.MOUSE_DOWN, mousePush);
			addEventListener(MouseEvent.MOUSE_UP, mouseRelease,false,0,true);
			drawGrid.startDrawing();
		}
		public function mouseRelease(m:MouseEvent)
		{
			trace("MouseUp");
			removeEventListener(MouseEvent.MOUSE_UP, mouseRelease);
			addEventListener(MouseEvent.MOUSE_DOWN, mousePush,false,0,true);
			drawGrid.stopDrawing();
			stage.removeChild(path);
			path = new Shape();
			stage.addChild(path);
			drawPath();
		}
		public function drawPath()
		{
			myBitMap = new BitmapData(stage.width, stage.height);
			myBitMap.draw(stage);
			findPathAStar(startPosX,startPosY);
			//findPathBestFirst(startPosX,startPosY);
		}
		public function findPathAStar(myX:Number, myY:Number)
		{
			startPosX = 0;
			startPosY = 0;
			endPosX = stage.width-1;
			endPosY = stage.height-1;
			open = new Vector.<myPos>();
			closed = new Vector.<myPos>();
			var myVec:Vector.<Number>;
			myVec = new Vector.<Number>();
			myVec.push(123);
			trace(myVec[0]);
			myVec.splice(0,0,456);
			trace(myVec[0]);
			pos = new Array(stage.width);
			for (var myInit:Number = 0; myInit<stage.width; myInit++)
			{
					pos[myInit] = new Array(stage.height);
			}
			pathFound = false;
			pos[startPosX][startPosY] = new myPos(startPosX,startPosY, 0, (Math.abs(endPosX - startPosX) + Math.abs(endPosY - startPosY))*10);
							
			open.push(pos[startPosX][startPosY]);
			//var rgb1:uint = myBitMap.getPixel(5,5);
			//trace(rgb1 & 0xffffff)
			//trace(rgb1>>16);
			//trace(rgb1>>8 & 0xff);
			//trace (rgb1 & 0xff);
			var modCount = 0;
			while(!pathFound)
			{
				//trace("hello");
				//if((modCount&0xff) == 0)
				//	open = radixSortF(open,0);
				//trace(open);
				//trace(modCount);
				if (open.length == 0)
					break;
				currentPos = open[0];
				//trace("its me");
				pos[currentPos.x][currentPos.y].myStatus = 2;
				closed.push(open.shift());
				//trace("gumby");
				findAdjacentAStar(currentPos);
				//pathFound = true;
				modCount++;
			}
			trace("path has been found");
			//open = radixSortF(open,0);
			open = radixSortH(open, 0);
			path = new Shape();
			//path.beginFill(0xFF0000);
			if (open.length == 0)
			{
				trace("invalid path");
				drawGrid.clearDrawing();
				return;
			}
			currentPos = open[0];
			if(currentPos.h == 0)
			{
				path.graphics.lineStyle(4, 0xFF0000);
				//trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
				path.graphics.moveTo(currentPos.x,currentPos.y);
				while(currentPos.x != 0 || currentPos.y !=0)
				{
					for each(var test in closed)
					{
						if(test.x == currentPos.lastX && test.y == currentPos.lastY)
						{
							currentPos = test;
							//trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
							path.graphics.lineTo(currentPos.x, currentPos.y);
							break;
						}
					}
					//trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
					path.graphics.lineTo(currentPos.x, currentPos.y);
				}
				stage.addChild(path);
			}
			else trace("path invalid");
			
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
		public function findAdjacentAStar(myPoint:myPos)
		{
			//trace(stage.width);
			//trace(stage.height);
			var myG:Number;
			var openTest:Boolean;
			myG = 10;
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
						//trace(pos[0]);
						if(pos[myPoint.x+i][myPoint.y+j] != undefined && pos[myPoint.x+i][myPoint.y+j].myStatus == 1)
						{
							if(pos[myPoint.x+i][myPoint.y+j].g >= myPoint.g + myG)
							{
								pos[myPoint.x+i][myPoint.y+j].g = myPoint.g + myG;
								pos[myPoint.x+i][myPoint.y+j].f = pos[myPoint.x+i][myPoint.y+j].g+pos[myPoint.x+i][myPoint.y+j].h;
								pos[myPoint.x+i][myPoint.y+j].lastX = myPoint.x;
								pos[myPoint.x+i][myPoint.y+j].lastY = myPoint.y;
								open.splice(open.indexOf(pos[myPoint.x+i][myPoint.y+j]),1);
								//*
								var myH2:Number = (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10;
								var numAdded2:Number = 0;
								if(open.length == 0) open.push(pos[myPoint.x+i][myPoint.y+j]);
								else
								{
									for(var toSplice2:Number = 0; toSplice2 < open.length; toSplice2++)
									{
										if(open[toSplice2].f >= myH2 + myPoint.g+myG)
										{
											numAdded2++;
											//trace(toSplice-1);
											//trace("adding pos x: "+myPoint.x+i);
											open.splice(toSplice2, 0, pos[myPoint.x+i][myPoint.y+j]);
											//trace(open);
											break;
										}
										if(numAdded2==0)open.push(pos[myPoint.x+i][myPoint.y+j]);
									}
								}
								//*/
								
							}
							openTest = true;
						}
						if(pos[myPoint.x+i][myPoint.y+j] != undefined && openTest == false)
						{
							if(pos[myPoint.x+i][myPoint.y+j].myStatus == 2)
							{
								openTest = true;
							}
						}
						if(openTest == false)
						{
							pos[myPoint.x+i][myPoint.y+j] = new myPos(myPoint.x+i,myPoint.y+j,myPoint.g+myG, (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10);
							pos[myPoint.x+i][myPoint.y+j].lastX = myPoint.x;
							pos[myPoint.x+i][myPoint.y+j].lastY = myPoint.y;
							pos[myPoint.x+i][myPoint.y+j].myStatus = 1;
							var numAdded:Number = 0;
							if(open.length == 0)
							{
								open.push(pos[myPoint.x+i][myPoint.y+j]);
								numAdded++;
							}
							else
							{
								var myH:Number = (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10;
								for(var toSplice:Number = 0; toSplice < open.length; toSplice++)
								{
									if(open[toSplice].f >= myH + myPoint.g+myG)
									{
										numAdded++;
										//trace(toSplice-1);
										//trace("adding pos x: "+myPoint.x+i);
										open.splice(toSplice, 0, pos[myPoint.x+i][myPoint.y+j]);
										//trace(open);
										break;
									}
								}
								if(numAdded==0)open.push(pos[myPoint.x+i][myPoint.y+j]);
							}
							/*
							pos[myPoint.x+i][myPoint.y+j] = new myPos(myPoint.x+i,myPoint.y+j,myPoint.g+myG, (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10);
							open.push(pos[myPoint.x+i][myPoint.y+j]);
							open[open.length-1].lastX = myPoint.x;
							open[open.length-1].lastY = myPoint.y;
							open[open.length-1].myStatus = 1;
							*/
						}
					}
				}
			}
			if(open.length == 0) pathFound = true;
		}
	}
}
