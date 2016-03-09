package;

import flash.desktop.ClipboardFormats;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxZoomCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.util.FlxColor;
class PlayState extends FlxState
{
	public var player:Player;
	private var _level:TiledLevel;
	private var _howto:FlxText;
	private var zoomValue:Float = 2.2;
	
	
	public var items:FlxTypedGroup<Item> = null;
	public var enemies:FlxTypedGroup<Enemy> = null;
	public var list:Array<String> = new Array<String>();
	public var exit:FlxSprite = null;
	
	public var timeText:FlxText = null;
	
	public var timeValueText:FlxText = null;
	
	private var time:Float = 60;
	
	private var recipeText:FlxText = null;
	
	var showExit:Bool = false;
	
	private var playerHealth:FlxText = null;
	
	private var hud:Hud = null;
	
	override public function create():Void
	{
		#if !mobile
			FlxG.mouse.visible = false;
		#end
				

		
		bgColor = FlxColor.RED;
		items =  new FlxTypedGroup<Item> ();
		enemies =  new FlxTypedGroup<Enemy> ();

		// Load the level's tilemaps
		_level = new TiledLevel(Reg.levels[Reg.level]);
		
		// Add tilemaps
		add(_level.backgroundTiles);
		
		// Add tilemaps
		add(_level.foregroundTiles);
		
		// Load player and objects of the Tiled map
		_level.loadObjects(this);
		
		add(items);
		add(enemies);
		add(exit);
		
		//FlxG.camera.zoom = 3;
		////FlxG.camera.width = Std.int(FlxG.camera.width / 3);
		////FlxG.camera.height = Std.int(FlxG.camera.height / 3);
		//FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON, 0);
//
		////FlxG.camera = new FlxCamera(0, 0, 640, 480);
		//////FlxG.camera.width = Std.int(FlxG.width / zoomValue);
		//////FlxG.camera.height = Std.int(FlxG.height / zoomValue);
		////FlxG.camera.follow(player);
		//////FlxG.camera.zoom = 1.5;

		
		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT,.5);

				// New zoom value
		//var zoom = 2;
		//// Percentage of aforementioned clipped "projection plane real-estate"
		//var factor = (zoom - 1) / (zoom * 2);
		//// Differences along X and Y
		//var dx = FlxG.width * factor;
		//var dy = FlxG.height * factor;
		//// The observable slice of the game world (top-left corner position and dimensions)
		//var worldX = 0;
		//var worldY = 0;
		//var worldWidth = FlxG.width;
		//var worldHeight =  FlxG.height;
		//// Update zoom
		//FlxG.camera.zoom = 2;
		//// Update scroll bounds
		//FlxG.camera.setScrollBoundsRect(worldX - dx, worldY - dy, worldWidth + dx, worldHeight + dy);
		
	//	FlxG.camera.zoom = zoom;
		
		#if !mobile
		
		setZoom(zoomValue);	
		// Set and create Txt Howto
		_howto = new FlxText(0, 225, FlxG.width);
		_howto.alignment = CENTER;
		//_howto.text = "Use the ARROW KEYS or WASD to move around.";
		_howto.scrollFactor.set(0, 0);
		add(_howto);
		#end
		
				//timeText = new FlxText(offSetX + 250, offSetY + 28, -1, "Time");
		timeText = new FlxText( 255,  1, -1, "Time");
		timeText.setFormat(null, 8, FlxColor.WHITE, "center");
		timeText.scrollFactor.set(0, 0);
		add(timeText);
		
		//timeValueText = new FlxText(offSetX + 290, offSetY + 28, -1, "0");
		timeValueText = new FlxText(290, 1, -1, "200");
		timeValueText.setFormat(null, 8, FlxColor.WHITE, "center");
		timeValueText.scrollFactor.set(0, 0);
		add(timeValueText);
		
				//timeValueText = new FlxText(offSetX + 290, offSetY + 28, -1, "0");
		recipeText = new FlxText(5, FlxG.height - 20 , -1, "recipe: " + list.toString());
		recipeText.setFormat(null, 8, FlxColor.WHITE, "center");
		recipeText.scrollFactor.set(0, 0);
		recipeText.setBorderStyle(OUTLINE_FAST, FlxColor.GRAY, 2);
		add(recipeText);
		
		playerHealth = new FlxText(5, 1, -1, "Health: " + player.health);
		playerHealth.setFormat(null, 8, FlxColor.WHITE, "center");
		playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
		//trace(list.toString());
		
		add(player);
		time = time * (Reg.level + 1);
		
		
		//hud = new Hud();
		//_hudCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height,zoomValue);
		//_hudCamera.follow(hud.background);
		//FlxG.cameras.add(_hudCamera);
	}
	
	function checkPlayerPosition(enemy:Enemy):Void
	{
		if (FlxMath.distanceToPoint(enemy, player.getMidpoint()) < 50) {
		
			if (FlxMath.distanceToPoint(enemy, player.getMidpoint()) <=10)
				enemy.attack();
			else{
				FlxVelocity.moveTowardsObject(enemy, player, 65);
				enemy.walk();
			}
			
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Collide with foreground tile layer
		if (_level.collideWithLevel(player))
		{
			// Resetting the movement flag if the player hits the wall 
			// is crucial, otherwise you can get stuck in the wall
			player.moveToNextTile = false;
		}
		
		FlxG.collide(enemies, _level.foregroundTiles);
		
		FlxG.overlap(player, items, OnItemOverlap);
		FlxG.overlap(player, enemies, OnEnemyOverlap);
		FlxG.overlap(player, exit, OnExitOverlap);
		
		enemies.forEach(checkPlayerPosition);
		
		time -= FlxG.elapsed;
		
		timeValueText.text = Std.string(Std.int(time));
		list.length > 0 ? recipeText.text = "recipe: " + list.toString() : recipeText.text = "find the portal";
		playerHealth.text = "Health: " + player.health;
		
		exit.visible = exit.active = list.length == 0 ;
		
		if (player.isDead || time <= 0)
			FlxG.resetState();
			
		enemyCooldown += elapsed;
	}
	
	private var counter:Float = 0;
	public function OnExitOverlap(player:Player,exit:FlxSprite):Void
	{
		if (!exit.active)
			return;
			
		counter += FlxG.elapsed;
		
		if (counter > 0.5){
			Reg.level++;
			if (Reg.level < Reg.levels.length)
				FlxG.switchState(new PlayState());
			else
				FlxG.resetGame();
		}
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		player = null;
		_level = null;
		_howto = null;
	}
	
	
	private function OnItemOverlap(player:Player,item:Item){
		
		if(Lambda.has(list,item.name)){
			player.collect(item);
			item.kill();
			list.remove(item.name);
			
			if (list.length == 0){
				recipeText.text = "find the portal";
				exit.visible = true;
			}
			
		}
	}
	
	private var enemyCooldown:Float = 0.7;
	var _hudCamera:FlxCamera = null;
	private function OnEnemyOverlap(player:Player,enemy:Enemy){
		
		if (enemyCooldown >= 0.7)
		{
			player.takeDamage(enemy.attackValue);
			
			if (player.atacking)
				enemy.takeDamage();
			
			enemyCooldown = 0;
		}
	}
	
	
	
	public function setZoom(zoom:Float):Void
	{
		
		var worldX = 0;
		var worldY = 0;
		var worldWidth = FlxG.width;
		var worldHeight =  FlxG.height;
		
		if (zoom < .5) zoom = .5;
		if (zoom > 4) zoom = 4;
		
		zoom = Math.round(zoom * 10) / 10; // corrects float precision problems.
		
		FlxG.camera.zoom = zoom;
		
		#if TRUE_ZOOM_OUT
		zoom += 0.5; // For 1/2 zoom out.
		zoom -= (1 - zoom); // For 1/2 zoom out.
		#end
		
		var zoomDistDiffY;
		var zoomDistDiffX;
		
		
		if (zoom <= 1) 
		{
			zoomDistDiffX = Math.abs((worldX + worldWidth) - (worldX + worldWidth) / 1 + (1 - zoom));
			zoomDistDiffY = Math.abs((worldY + worldHeight) - (worldY + worldHeight) / 1 + (1 - zoom));
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise -0.5 
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise -0.5
			#else
			zoomDistDiffX *= -.5;
			zoomDistDiffY *= -.5;
			#end
		}
		else
		{
			zoomDistDiffX = Math.abs((worldX + worldWidth) - (worldX + worldWidth) / zoom);
			zoomDistDiffY = Math.abs((worldY + worldHeight) - (worldY + worldHeight) / zoom);
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise 0.5
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise 0.5
			#else
			zoomDistDiffX *= .5;
			zoomDistDiffY *= .5;
			#end
		}
		
		FlxG.camera.setScrollBoundsRect(worldX - zoomDistDiffX, 
							   worldY - zoomDistDiffY,
							   (worldWidth + Math.abs(worldX) + zoomDistDiffX * 2),
							   (worldHeight + Math.abs(worldY) + zoomDistDiffY * 2),
							   false);
	}
}
