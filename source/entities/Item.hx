package entities;

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
	
	public function new(?X:Float=0, ?Y:Float=0, itemName:String, itemType:Int) 
	{
		super(X, Y);
		name = itemName;
		
		loadGraphic("assets/images/items.png", true, 16, 16);
		
		animation.add("idle", [itemType]);
		animation.play("idle");
	}
	
}