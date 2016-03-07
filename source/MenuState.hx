package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var instructions:FlxText = null;
	private var pressStart:FlxText = null;
	override public function create():Void
	{
		super.create();
		FlxG.state.bgColor = FlxColor.GREEN;
		
		Reg.levels = [];
		Reg.levels.push("assets/data/map.tmx");
		Reg.levels.push("assets/data/map2.tmx");
		Reg.level = 0;
		//Reg.maxLevel = Reg.levels.length + 1;
		
		instructions  = new FlxText(0,0,-1,"The King's dinner",16);
		instructions.x = FlxG.width/2 - instructions.width / 2;
		instructions.y = FlxG.height / 2 + 50;
		instructions.setFormat(null, 16, FlxColor.BLACK);
		instructions.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);

		add(instructions);
		
		add(new FlxSprite( FlxG.width / 2 - 85 , 30, "assets/images/8653.resized.png"));
		
		pressStart  = new FlxText(0,0,-1,"press any key to play",8);
		pressStart.x = FlxG.width/2 - pressStart.width / 2;
		pressStart.y = FlxG.height / 2 + 100;
		pressStart.setFormat(null, 8, FlxColor.BLACK);
		pressStart.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		//pressStart.addFormat(new FlxTextFormat(0x808080, false, false, 0x373737));
		add(pressStart);
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
