package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

enum EnemyType{
	MERODEADOR;
	ZONAL;
	PERSEGUIDOR;
}
	

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite
{
	public var attackValue:Int = 20;

	
	private static inline var TILE_SIZE:Int = 16;
	private var enemyType:Int = 0;
	//private var health:Int = 100;
	private var cooldown:Float = 1;
	private var timeCounter:Float = 0;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?eEnemyType:Int) 
	{
		super(X, Y);
		
		var color:FlxColor = FlxColor.TRANSPARENT;
		
		switch (eEnemyType) 
		{
			case 0:
				loadGraphic("assets/images/rocky.png", true, 16, 16);
				animation.add("idle", [0]);
				animation.add("walk", [1, 2],20);
				animation.add("attack", [3, 4],20);
				attackValue = 10;
			case 1:
				loadGraphic("assets/images/fire.png", true, 16, 16);
				animation.add("idle", [0]);
				animation.add("walk", [1, 2],20);
				animation.add("attack", [3, 4],20);
				attackValue = 20;
			case 2:
				loadGraphic("assets/images/dark.png", true, 16, 16);
				animation.add("idle", [0]);
				animation.add("walk", [1, 2],20);
				animation.add("attack", [3, 4],20);
				attackValue = 40;
			//default:
				//color = FlxColor.BLACK;
		}
		//eEnemyType == 1 ? color = FlxColor.MAGENTA : color = FlxColor.PURPLE);
		
		//makeGraphic(TILE_SIZE, TILE_SIZE, color);
		
		enemyType = eEnemyType;
		
		health = 100;
		
		animation.play("idle");
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if(enemyType == 0){
			
		}
		
		if(enemyType == 1){
			
		}
		
		if(enemyType == 2){
			
		}
		
		if (cooldown <= 2)
			cooldown += elapsed;
	}
	
	public function takeDamage():Void
	{
		trace("takeDamege");
		trace("enemy health: " + health);
		if(cooldown >= 2){
			health -= 50;
			
			if (health <= 0)
				kill();
			
			cooldown = 0;
		}
	}
	
	public function attack():Void
	{
		animation.play("attack");
	}
	
	public function walk():Void
	{
		animation.play("walk");
	}
	
	private function wander():Void{
		
		//if(!isWandering){
			//
		//}else{
			//
		//}
	}
}