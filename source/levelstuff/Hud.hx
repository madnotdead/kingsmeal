//package levelstuff;
//
//import flixel.FlxG;
//import flixel.FlxSprite;
//import flixel.group.FlxGroup.FlxTypedGroup;
//import flixel.text.FlxText;
//import flixel.util.FlxColor;
//using flixel.util.FlxSpriteUtil;
//
//class Hud extends FlxTypedGroup<FlxSprite>
//{
	//private var _sprBack:FlxSprite;
	//private var _txtHealth:FlxText;
	//private var _txtMoney:FlxText;
	//private var _sprHealth:FlxSprite;
	//private var _sprMoney:FlxSprite;
	//
	//public function new() 
	//{
		//super();
		//_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		//_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		//_txtHealth = new FlxText(16, 2, 0, "3 / 3", 8);
		//_txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		//_txtMoney = new FlxText(0, 2, 0, "0", 8);
		//_txtMoney.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		//_sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4,"assets/images/health.png");
		//_sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4,"assets/images/coin.png");
		//_txtMoney.alignment = RIGHT;
		//_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		//add(_sprBack);
		//add(_sprHealth);
		//add(_sprMoney);
		//add(_txtHealth);
		//add(_txtMoney);
		//
		//// HUD elements shouldn't move with the camera
		//forEach(function(spr:FlxSprite)
		//{
			//spr.scrollFactor.set(0, 0);
		//});
	//}
	//
	//public function updateHUD(Health:Int = 0, Money:Int = 0):Void
	//{
		//_txtHealth.text = Health + " / 3";
		//_txtMoney.text = Std.string(Money);
		//_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
	//}
//}
package levelstuff;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Hud extends FlxGroup
{
	public var width:Int = 200;
	public var height:Int = FlxG.height;
	public var background:FlxSprite;
	
	private var timeText:FlxText;
	private var timeValueText:FlxText;
	private var recipeText:FlxText;
	private var playerHealth:FlxText;
	
	public function new() 
	{
		super();
		
		var x:Int = 10000;
		
		background = new FlxSprite(x, 0);
		background.makeGraphic(FlxG.width, height, FlxColor.TRANSPARENT);
		add(background);
		
		x += 6;
		var startY:Int = 10;
		
		timeText = new FlxText(x,  startY, -1, "Time");
		timeText.setFormat(null, 16, FlxColor.WHITE, "center");
		//timeText.scrollFactor.set(0, 0);	
		add(timeText);
		
		timeValueText = new FlxText(x + 55, startY, -1, "200");
		timeValueText.setFormat(null, 16, FlxColor.WHITE, "center");
		//timeValueText.scrollFactor.set(0, 0);
		add(timeValueText);
		//
		recipeText = new FlxText(x, FlxG.height - 35 , -1, "recipe: pepermint, garlic");

		recipeText.setFormat(null, 16, FlxColor.WHITE, "center");
		//recipeText.scrollFactor.set(0, 0);
		recipeText.setBorderStyle(OUTLINE_FAST, FlxColor.GRAY, 2);
		add(recipeText);
		//
		playerHealth = new FlxText(x + FlxG.width - 125, startY, -1, "Health: ");
		playerHealth.setFormat(null, 16, FlxColor.WHITE, "center");
		//playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
		
		trace("finalX: " + x);
	}
	
	public function updateHealth(health:Float):Void{
		playerHealth.text =  "Health: " + health;
	}
	
	public function updateTime(time:Float) 
	{
		timeValueText.text = Std.string(Std.int(time));
	}
	
	public function setRecipe(recipe:String)
	{
		recipeText.text = recipe;
	}
}
////package levelstuff;
////
////
////import flixel.FlxG;
////import flixel.FlxSprite;
////import flixel.group.FlxGroup;
////import flixel.group.FlxGroup.FlxTypedGroup;
////import flixel.text.FlxText;
////import flixel.util.FlxColor;
////
/////**
 ////* ...
 ////* @author madnotdead
 ////*/
////class Hud extends FlxTypedGroup<FlxSprite>
////{
	////public var background:FlxSprite = null;
	////var playerHealth:FlxText = null;
	////
	////public function new() 
	////{
		////super();
		////background = new FlxSprite(0, 0);
		////background.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		//////background.alpha = 0.5;
		////add(background);
		////
		////playerHealth = new FlxText(5, 1, -1, "Health: 100");
		////playerHealth.setFormat(null, 8, FlxColor.WHITE, "center");
		//////playerHealth.scrollFactor.set(0, 0);
		////add(playerHealth);
	////}
	////
	////
	////public function updateHealth(health:Float):Void{
		////playerHealth.text =  "Health: " + health;
	////}
	////
////}