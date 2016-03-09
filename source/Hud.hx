package;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author madnotdead
 */
class Hud extends FlxTypedGroup<FlxSprite>
{
	public var background:FlxSprite = null;
	var playerHealth:FlxText = null;
	
	public function new() 
	{
		super();
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		//background.alpha = 0.5;
		add(background);
		
		playerHealth = new FlxText(5, 1, -1, "Health: 100");
		playerHealth.setFormat(null, 8, FlxColor.WHITE, "center");
		//playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
	}
	
	
	public function updateHealth(health:Float):Void{
		playerHealth.text =  "Health: " + health;
	}
	
}