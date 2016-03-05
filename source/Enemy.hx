package;

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
	public function new(?X:Float=0, ?Y:Float=0,?eEnemyType:Int) 
	{
		super(X, Y);
		
		var color:FlxColor = FlxColor.TRANSPARENT;
		
		switch (eEnemyType) 
		{
			case 0:
				color = FlxColor.MAGENTA;
				attackValue = 10;
			case 1:
				color = FlxColor.LIME;
				attackValue = 20;
			case 3:
				color = FlxColor.PURPLE;
				attackValue = 40;
			default:
				color = FlxColor.BLACK;
		}
		//eEnemyType == 1 ? color = FlxColor.MAGENTA : color = FlxColor.PURPLE);
		
		makeGraphic(TILE_SIZE, TILE_SIZE, color);
		
		enemyType = eEnemyType;
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
		
		if (cooldown <= 0)
			cooldown += elapsed;
	}
	
	public function takeDamage():Void
	{
		if(cooldown >= 2){
			health -= 50;
			
			if (health <= 0)
				kill();
			
			cooldown = 0;
		}
	}
}