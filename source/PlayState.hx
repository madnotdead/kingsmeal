package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
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
		timeText = new FlxText( 265,  1, -1, "Time");
		timeText.setFormat(null, 10, FlxColor.WHITE, "center");
		timeText.scrollFactor.set(0, 0);
		add(timeText);
		
		//timeValueText = new FlxText(offSetX + 290, offSetY + 28, -1, "0");
		timeValueText = new FlxText(300, 1, -1, "200");
		timeValueText.setFormat(null, 10, FlxColor.WHITE, "center");
		timeValueText.scrollFactor.set(0, 0);
		add(timeValueText);
		
		list.push("pimienta");
		list.push("pimienta");
		list.push("pimienta");
		list.push("pimienta");
		list.push("ajo");
		
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
		
		FlxG.overlap(player, items, OnItemOverlap);
		FlxG.overlap(player, enemies, OnEnemyOverlap);
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
		}
	}
	
	private function OnEnemyOverlap(player:Player,enemy:Enemy){
		
		player.takeDamage(enemy.attackValue);
		
		if (player.atacking)
			enemy.takeDamage();
	}
}
