package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class GameOverState extends FlxState
{
	private var instructions:FlxText = null;
	private var madnotdead:FlxText = null;
	override public function create():Void
	{
		super.create();
		
		instructions  = new FlxText(0,0,-1,"Thanks for playing",16);
		instructions.x = FlxG.width/2 - instructions.width / 2;
		instructions.y = FlxG.height / 2 + 50;
		instructions.setFormat(null, 16, FlxColor.BLACK);
		instructions.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);

		add(instructions);
		
		
		madnotdead  = new FlxText(0,0,-1,"@madnotdead",16);
		madnotdead.x = FlxG.width/2 - madnotdead.width / 2;
		madnotdead.y = FlxG.height / 2 + 90;
		madnotdead.setFormat(null, 16, FlxColor.BLACK);
		madnotdead.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);

		add(madnotdead);
		
		add(new FlxSprite( FlxG.width / 2 - 85 , 30, "assets/images/8653.resized.png"));
		//add(new FlxSprite( FlxG.width / 2 - 85 , 30, "assets/images/8653.resized.png"));
	}
}