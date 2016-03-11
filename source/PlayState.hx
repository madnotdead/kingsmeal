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
	
	public static var hudCam:FlxCamera = null;
	
	override public function create():Void
	{
		#if !mobile
			FlxG.mouse.visible = false;
		#end
				

		
		//bgColor = FlxColor.RED;
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
		
	
		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT,.5);

		setZoom(zoomValue);	
		
		#if !mobile
		// Set and create Txt Howto
		_howto = new FlxText(0, 225, FlxG.width);
		_howto.alignment = CENTER;
		//_howto.text = "Use the ARROW KEYS or WASD to move around.";
		_howto.scrollFactor.set(0, 0);
		add(_howto);
		#end
		

		
		add(player);
		time = time * (Reg.level + 1);
		
		
		//hud = new Hud();
		//_hudCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height,zoomValue);
		//_hudCamera.follow(hud.background);
		//FlxG.cameras.add(_hudCamera);
		
		hud = new Hud();
		add(hud);

		
		#if TRUE_ZOOM_OUT
		hudCam = new FlxCamera(440 + 50, 0 + 45, hud.width, hud.height); // +50 + 45 For 1/2 zoom out.
		#else
		hudCam = new FlxCamera(0, 0, FlxG.width, hud.height);
		#end
		hudCam.zoom = 1; // For 1/2 zoom out.
		hudCam.follow(hud.background, FlxCameraFollowStyle.NO_DEAD_ZONE);
		///hudCam.alpha = .5;
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam);
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
		
		hud.updateHealth(player.health);
		hud.updateTime(time);
		//timeValueText.text = Std.string(Std.int(time));
		//list.length > 0 ? recipeText.text = "recipe: " + list.toString() : recipeText.text = "find the portal";
		//playerHealth.text = "Health: " + player.health;
		
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
	
	public function SetZoom1(zoom:Float):Void{
		// New zoom value

		// Percentage of aforementioned clipped "projection plane real-estate"
		var factor = (zoom - 1) / (zoom * 2);
		// Differences along X and Y
		var dx = FlxG.width * factor;
		var dy = FlxG.height * factor;
		// The observable slice of the game world (top-left corner position and dimensions)
		var worldX = 0;
		var worldY = 0;
		var worldWidth = FlxG.width;
		var worldHeight =  FlxG.height;
		// Update zoom
		FlxG.camera.zoom = 2;
		// Update scroll bounds
		FlxG.camera.setScrollBoundsRect(worldX - dx, worldY - dy, worldWidth + dx, worldHeight + dy);
	}
}
