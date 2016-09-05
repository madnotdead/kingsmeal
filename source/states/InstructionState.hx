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
class InstructionState extends FlxState
{

	private var header:FlxText = null;
	private var instructions:FlxText = null;
	private var instructions1:FlxText = null;
	private var instructions2:FlxText = null;
	private var instructions3:FlxText = null;
	
	override public function create():Void 
	{
		super.create();
		
		//header  = new FlxText(0,0,-1,"the king is the king",8);
		//header.x = FlxG.width/2 - header.width / 2;
		//header.y = 10;
		//header.setFormat(null, 16, FlxColor.BLACK, "center");
		//header.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		//add(header);
		
		instructions  = new FlxText(0,0,-1,"It's the king's birthday",8);
		instructions.x = FlxG.width/2 - instructions.width / 2;
		instructions.y = 25;
		instructions.setFormat(null, 16, FlxColor.BLACK, "center");
		instructions.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		add(instructions);
		
		instructions1  = new FlxText(0,0,-1,"Some ingredients are missing",8);
		instructions1.x = FlxG.width/2 - instructions1.width / 2;
		instructions1.y = 100;
		instructions1.setFormat(null, 16, FlxColor.BLACK, "center");
		instructions1.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		add(instructions1);
		
		instructions2  = new FlxText(0,0,-1,"We must find them!",8);
		instructions2.x = FlxG.width/2 - instructions2.width / 2;
		instructions2.y =  125;
		instructions2.setFormat(null, 16, FlxColor.BLACK, "center");
		instructions2.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		add(instructions2);

		//instructions3  = new FlxText(0,0,-1,"It's dangerous to go alone, take this recipe with you",8);
		//instructions3.x = FlxG.width/2 - instructions3.width / 2;
		//instructions3.y =  90;
		//instructions3.setFormat(null, 16, FlxColor.BLACK, "center");
		//instructions3.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		//add(instructions3);
		//"It's the king's birthday, we have to cook but some ingredients are missing"
		//"We must find them!"
		//"It's dangerous to go alone, take this recipe with you"
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		#if mobile
		if (FlxG.touches.list.length > 0)
			FlxG.switchState(new PlayState());
		#else
		if (FlxG.keys.pressed.ANY)
			FlxG.switchState(new PlayState());
		#end
	}
}