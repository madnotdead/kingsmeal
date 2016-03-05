package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Item extends FlxSprite
{
	public var name:String = "";
	
	public function new(?X:Float=0, ?Y:Float=0, itemName:String) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.CYAN);
		name = itemName;
	}
	
}