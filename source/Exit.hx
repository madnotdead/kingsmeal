package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Exit extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/portal.png", true, 22, 24);
		animation.add("active", [0, 1, 2],10);
		animation.play("active");
	}
	
}