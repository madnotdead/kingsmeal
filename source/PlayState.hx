package;

import flash.desktop.ClipboardFormats;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
	private var zoomValue:Float = 2.0;
	
	
	public var items:FlxTypedGroup<Item> = null;
	public var enemies:FlxTypedGroup<Enemy> = null;
	public var list:Array<String> = new Array<String>();
	public var exit:FlxSprite = null;
	
	public var timeText:FlxText = null;
	
	public var timeValueText:FlxText = null;
	
	private var time:Float = 60;
	
	private var recipeText:FlxText = null;
	
	var showExit:Bool = false;
	
	private var playerHealt:FlxText = null;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		bgColor = 0xFF18A068;
		items =  new FlxTypedGroup<Item> ();
		enemies =  new FlxTypedGroup<Enemy> ();

		// Load the level's tilemaps
		_level = new TiledLevel("assets/data/map.tmx");
		
		// Add tilemaps
		add(_level.backgroundTiles);
		
		// Add tilemaps
		add(_level.foregroundTiles);
		
		// Load player and objects of the Tiled map
		_level.loadObjects(this);
		
		add(items);
		add(enemies);
		add(exit);
		
		FlxG.camera.zoom = 2;
		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT);
		
		
		#if !mobile
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
		add(recipeText);
		
		playerHealt = new FlxText(5, 1, -1, "Health: " + player.health);
		playerHealt.setFormat(null, 8, FlxColor.WHITE, "center");
		playerHealt.scrollFactor.set(0, 0);
		add(playerHealt);
		//trace(list.toString());
	}
	
	function checkPlayerPosition(enemy:Enemy):Void
	{
		if(FlxMath.distanceToPoint(enemy,player.getMidpoint()) < 50){
			FlxVelocity.moveTowardsObject(enemy, player, 65);
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
		recipeText.text = "recipe: " + list.toString();
		playerHealt.text = "Health: " + player.health;
		
		exit.visible = list.length == 0 ;
	}
	
	private var counter:Float = 0;
	public function OnExitOverlap(player:Player,exit:FlxSprite):Void
	{
		counter += FlxG.elapsed;
		
		if (counter > 1.5){
			//siguiente nivel
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
				recipeText.visible = false;
				exit.visible = true;
			}
			
		}
	}
	
	private function OnEnemyOverlap(player:Player,enemy:Enemy){
		
		player.takeDamage(enemy.attackValue);
		
		if (player.atacking)
			enemy.takeDamage();
	}
}
