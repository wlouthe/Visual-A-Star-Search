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
		var pos:Array;
		
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
			startPosX = 0;
			startPosY = 0;
			endPosX = stage.width-1;
			endPosY = stage.height-1;
			open = new Vector.<myPos>();
			closed = new Vector.<myPos>();
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
				//if((modCount&0xf) == 0)
				//	open = radixSortF(open,0);
				//trace(open);
				currentPos = open[0]
				//trace("its me");
				pos[currentPos.x][currentPos.y].myStatus = 2;
				closed.push(open.shift());
				//trace("chun lee");
				findAdjacent(currentPos);
				//pathFound = true;
				//modCount++;
			}
			trace("path has been found");
			//open = radixSortF(open,0);
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
						//trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
						path.graphics.lineTo(currentPos.x, currentPos.y);
						break;
					}
				}
				//trace("x:"+(currentPos.x) +"; y:" + (currentPos.y) + "; g:" + (currentPos.g) + "; h:" + (currentPos.h) + "; f:" + (currentPos.f) + "; lastX:" + (currentPos.lastX) + "; lastY:" + (currentPos.lastY));
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
								{
								var myH:Number = (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10;
								var myMod:int = 2;
								var modHop:int = 0;
								var toSplice:int = open.length/2;
								if(toSplice == 0) toSplice++;
								var autoBreak:int = 0;
								while(modHop == 0)
								{
									trace("toSplice:"+toSplice+" open.length:"+open.length);
									//trace ("lst: " + open[toSplice].f +" current: " + (myH+myPoint.g+myG));
									if(open[toSplice].f < myH + myPoint.g+myG)
									{
										myMod = myMod*2;
										toSplice+=open.length/myMod;
										if(toSplice > open.length)
										{
											toSplice = open.length;
											autoBreak++;
										}
										continue;
									}
									if(open[toSplice].f > myH + myPoint.g+myG)
									{
										myMod = myMod*2;
										toSplice-=open.length/myMod;
										if(toSplice < 0)
										{
											toSplice = 0;
											autoBreak++;
										}
										continue;
									}
									
									if(open[toSplice].f == myH + myPoint.g+myG || autoBreak == 1)
									{
										modHop = 1;
										if(toSplice < 0) toSplice = 0;
										while(open[toSplice].f == myH+myPoint.g+myG)
										{
											if(toSplice == 0)
												break;
											toSplice--;
										}
										toSplice++;
										//trace(toSplice-1);
										//trace("adding pos x: "+myPoint.x+i);
										open.splice(toSplice, 0, pos[myPoint.x+i][myPoint.y+j]);
										//trace(open);
										break;
									}
								}
							}
								
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
							if(open.length == 0) open.push(pos[myPoint.x+i][myPoint.y+j]);
							
							else
							{
								var myH:Number = (Math.abs(endPosX - (myPoint.x+i)) + Math.abs(endPosY - (myPoint.y+j)))*10;
								var myMod:int = 1;
								var modHop:int = 0;
								var toSplice:uint = open.length/2;
								if(toSplice == 0) toSplice++;
								var toSpliceCount = 0;
								var autoBreak:int = 0;
								while(modHop == 0)
								{
									//trace("toSplice:"+toSplice+" open.length:"+open.length);
									//trace ("lst: " + open[toSplice].f +" current: " + (myH+myPoint.g+myG));
									if(open[toSplice].f < myH + myPoint.g+myG)
									{
										myMod = myMod<<2;
										toSplice+=open.length>>myMod;
										if(toSplice > open.length)
										{
											toSplice = open.length;
											autoBreak++;
										}
										continue;
									}
									if(open[toSplice].f > myH + myPoint.g+myG)
									{
										myMod = myMod<<1;
										toSplice-=open.length>>myMod;
										if(toSplice < 0)
										{
											toSplice = 0;
											autoBreak++;
										}
										continue;
									}
									
									if(open[toSplice].f == myH + myPoint.g+myG || autoBreak == 1)
									{
										modHop = 1;
										if(toSplice < 0) toSplice = 0;
										while(open[toSplice].f == myH+myPoint.g+myG)
										{
											if(toSplice == 0)
												break;
											toSplice--;
										}
										toSplice++;
										//trace(toSplice-1);
										//trace("adding pos x: "+myPoint.x+i);
										open.splice(toSplice, 0, pos[myPoint.x+i][myPoint.y+j]);
										//trace(open);
										break;
									}
								}
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
		}
	}
}
