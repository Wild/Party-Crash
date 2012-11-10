#pragma strict

class Player {
	var player : GameObject;
	var control : CameraRelativeControl;
	var transform : Transform;
	var character : CharacterController;
	var exVelocity : Vector3;
	var moveJoystick : Joystick;

  	public function Player(thePlayer : GameObject){
    	this.player = thePlayer;
    	this.control = thePlayer.GetComponent(CameraRelativeControl);
    	this.transform = thePlayer.GetComponent(Transform );
		this.character = thePlayer.GetComponent(CharacterController);
		this.exVelocity = Vector3.zero;
		this.moveJoystick = this.control.moveJoystick;
	}
}

class PlayerHit {
	var player : Player;
	var afterHitVelocity : Vector3;
	
	public function PlayerHit(thePlayer : Player, afterhit : Vector3) {
		this.player = thePlayer;
		this.afterHitVelocity = afterhit;
	}
}

public var iceFriction : float = 1.0;
private var players : Array;
private var playersHit : Array;

function Start () {
	var playersGameObjects = GameObject.FindGameObjectsWithTag("Player");
	var length = playersGameObjects.Length;
	players = new Array();
	playersHit = new Array();
	
	for (var i = 0; i < length; i++) {
		players.Add(new Player(playersGameObjects[i]));
	}
}

// Update all players' movement!
function Update () {

	var length = players.length;
	for (var i = 0; i < length; i++) {
		var player : Player = players[i];
		applyMovement(player);
	}
}

function applyMovement(player : Player) {
    
    var movement = Vector3(player.moveJoystick.position.x, 0, player.moveJoystick.position.y);
	
	if (movement.magnitude > 0.1) {
		player.control.playerMoving();
	}
	
	// We only want the camera-space horizontal direction
	movement.y = 0;
	movement.Normalize(); // Adjust magnitude after ignoring vertical movement
	
	// Face the character to match with where it is moving
	FaceMovementDirection(player, movement);
	
	// Let's use the largest component of the joystick position for the speed.
	var absJoyPos = Vector2( Mathf.Abs(player.moveJoystick.position.x), Mathf.Abs(player.moveJoystick.position.y) );
	movement *= player.control.speed * ( (absJoyPos.x > absJoyPos.y) ? absJoyPos.x : absJoyPos.y);
	
	// Check for jump
	if ( player.character.isGrounded ) {
		player.control.canJump = true;
		
		// Apply ice effect (acceleration/deceleration)
		var frictionConverted = 1.0 - iceFriction;
		movement = movement * iceFriction + player.exVelocity * frictionConverted;
		
		// Apply player hit
		if (player.control.state == PlayerState.Hit) {
			movement = player.control.velocity;
			player.control.state = PlayerState.Simple;
		}
		// Not to exceed the max speed.
		else if ( (player.control.state == PlayerState.Simple && movement.magnitude > player.control.speed && movement.magnitude > player.exVelocity.magnitude) ) {
			movement = player.exVelocity;
		}
		
		// Adjust for attacking
		if (player.control.state == PlayerState.Attacking) {
			movement = player.transform.forward * player.control.actionSpeed;
			player.control.state = PlayerState.Simple;
		}
		
	}
	else {
		// Adjust additional movement while in-air
		movement.y += Physics.gravity.y * Time.deltaTime;
		movement.x *= player.control.inAirMultiplier;
		movement.z *= player.control.inAirMultiplier;
	}
	
	player.exVelocity = movement;
	
	movement += Physics.gravity;
	movement *= Time.deltaTime;
	
	// Actually move the character
	player.character.Move(movement);
	
	if ( player.character.isGrounded ) {
		// Remove any persistent velocity after landing
		player.control.velocity = Vector3.zero;
	}
}

function FaceMovementDirection(player : Player, playerVelocity : Vector3) {
	
	// If moving significantly in a new direction, point that character in that direction
	if ( playerVelocity.magnitude > 0.1 ) {
		var angle = Vector3.Angle(playerVelocity, player.transform.forward);
		if (angle > 0) {
			var rotated = Vector3.RotateTowards(player.transform.forward, playerVelocity, player.control.getRotationSpeed() * Time.deltaTime, 1.0);
			player.transform.forward = rotated.normalized;
		}
	}
}