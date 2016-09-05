package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */

 enum MoveDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class Player extends FlxSprite
{
	

	/**
	 * How big the tiles of the tilemap are.
	 */
	private static inline var TILE_SIZE:Int = 16;
	/**
	 * How many pixels to move each frame. Has to be a divider of TILE_SIZE 
	 * to work as expected (move one block at a time), because we use the
	 * modulo-operator to check whether the next block has been reached.
	 */
	private static inline var MOVEMENT_SPEED:Int = 2;
	
	/**
	 * Flag used to check if char is moving.
	 */ 
	public var moveToNextTile:Bool;
	
	public var isDead:Bool;
	public var atacking:Bool;
	/**
	 * Var used to hold moving direction.
	 */ 
	private var moveDirection:MoveDirection;
	
	#if mobile
	private var _virtualPad:FlxVirtualPad;
	#end
	
	private var _items:FlxGroup;
	
	private var _aura:FlxSprite;
	
	var attackingTime:Float = 2;
	
	var cooldown:Float = 2;
	
		public function new(X:Int, Y:Int)
	{
		// X,Y: Starting coordinates
		super(X, Y);
		
		// Make the player graphic.
		makeGraphic(TILE_SIZE, TILE_SIZE, 0xff2c3d55);
		loadGraphic("assets/images/player.png", true, TILE_SIZE, TILE_SIZE);
		
		animation.add("idle", [0]);
		animation.add("moving", [0,1,2]);

		_aura = new FlxSprite( X , Y,"assets/images/AURA.png");
		//_aura.makeGraphic(26, 26, FlxColor.WHITE);
		_aura.visible = false;
		
		FlxG.state.add(_aura);
		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		//_virtualPad.scale.set(1.5, 1.5);
		_virtualPad.camera = states.PlayState.hudCam;
		//_virtualPad.updateHitbox();
		FlxG.state.add(_virtualPad);
		#end
		
		_items = new FlxGroup();
		
		health = 100;
		animation.play("idle");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);  
		_aura.visible = false;
		// Move the player to the next block
		
		if (moveToNextTile)
		{
			switch (moveDirection)
			{
				case UP:
					y -= MOVEMENT_SPEED;
				case DOWN:
					y += MOVEMENT_SPEED;
				case LEFT:
					x -= MOVEMENT_SPEED;
				case RIGHT:
					x += MOVEMENT_SPEED;
			}
			animation.play("moving");
		}
		
		// Check if the player has now reached the next block
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			moveToNextTile = false;
		}
		
		#if mobile
		if (_virtualPad.buttonDown.pressed)
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (_virtualPad.buttonUp.pressed)
		{
			moveTo(MoveDirection.UP);
		}
		else if (_virtualPad.buttonLeft.pressed)
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (_virtualPad.buttonRight.pressed)
		{
			moveTo(MoveDirection.RIGHT);
		}
		#else
		// Check for WASD or arrow key presses and move accordingly
		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (FlxG.keys.anyPressed([UP, W]))
		{
			moveTo(MoveDirection.UP);
		}
		else if (FlxG.keys.anyPressed([LEFT, A]))
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			moveTo(MoveDirection.RIGHT);
		}
		else if (FlxG.keys.justPressed.Z) {
			
				atacking = true;
				_aura.visible = true;
		}
		#end
		
		attackingTime += elapsed;
		cooldown += elapsed;
		
		_aura.x = x - 5;
		_aura.y = y - 5;
		animation.play("idle");
		
	}
	
	public function moveTo(Direction:MoveDirection):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			moveToNextTile = true;
		}
	}
	
	public function collect(item:Item):Void
	{
		_items.add(item);
	}
	
	public function takeDamage(damage:Int):Void 
	{
		trace("player is being attacked");
		trace("current health: " + health);
		
		if(cooldown > 0.5){
			health -= damage;
			FlxG.camera.flash(FlxColor.RED, 0.1);
			if (health <= 0){
				isDead = true;
				FlxG.camera.shake();
			}
			
			cooldown = 0;
		}
	}
	
}