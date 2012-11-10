//////////////////////////////////////////////////////////////
// CameraRelativeControl.js
// Penelope iPhone Tutorial
//
// CameraRelativeControl creates a control scheme similar to what
// might be found in 3rd person platformer games found on consoles.
// The left stick is used to move the character, and the right
// stick is used to rotate the camera around the character.
// A quick double-tap on the right joystick will make the 
// character jump. 
//////////////////////////////////////////////////////////////

#pragma strict

// This script must be attached to a GameObject that has a CharacterController
@script RequireComponent( CharacterController )

enum PlayerState { Simple, Attacking, Hit }

var moveJoystick : Joystick;
var actionButton : ActionButton;
var actionEffects : ParticleSystem;
var enableKeyboardMovement : boolean = false;
var dashSound : AudioClip;
var moveSound : AudioClip;

private var playerModel : Transform;
private var audioSource : AudioSource;
private var character : CharacterController;
private var playersAfterHit : Array;
private var respawnPoint : Vector3;
private var rotationSpeed : float = 10;
var actionDelay : float = 2;
var actionSpeed : float = 8;
var afterHitDuration : float = 0.1;
var speed : float = 3;								// Ground speed
var jumpSpeed : float = 20;
var inAirMultiplier : float = 0.25; 				// Limiter for ground speed while jumping

var velocity : Vector3;						// Used for continuing momentum while in air
var canJump = true;
var state : PlayerState = PlayerState.Simple;

function Start() {
	//var camera = GameObject.FindWithTag("MainCamera");
	//audioSource = camera.audio;
	audioSource = gameObject.audio;

	character = GetComponent( CharacterController );
	playersAfterHit = new Array();
	respawnPoint = this.gameObject.transform.position;
	actionButton.setActionDelay(actionDelay);
	
	// Get player model (concrete)
	var comps = this.GetComponentsInChildren(Transform);
	for (var comp : Transform in comps) {
    	if (comp.tag == "PlayerModel") {
    		playerModel = comp;
    		break;
    	}
	}
}

function OnEndGame()
{
	// Disable joystick when the game ends	
	moveJoystick.Disable();
	
	// Don't allow any more control changes when the game ends
	this.enabled = false;
}

public function getPlayersAfterHit() {
	return playersAfterHit;
}

public function getVelocity() {
	return character.velocity;
}

public function getRespawnPoint() {
	return respawnPoint;
}

public function getRotationSpeed() {
	return rotationSpeed;
}

public function isStillAfterHit(name : String) {
	var stillInAfterHit = false;
	var length = playersAfterHit.length;
	for (var i = 0; i < length; i++) {
		if (playersAfterHit[i] == name) {
			stillInAfterHit = true;
			break;
		}
	}
	return stillInAfterHit;
}

public function removeAfterHit(name : String) {
	var length = playersAfterHit.length;
	for (var i = 0; i < length; i++) {
		if (playersAfterHit[i] == name) {
			playersAfterHit.RemoveAt(i);
			break;
		}
	}
}

public function getHit(opponent : GameObject, continueOpponent : boolean) {

	var opponentName = opponent.transform.parent.name;

	if (state != PlayerState.Hit && !isStillAfterHit(opponentName)) {
		
		var opponentScript : CameraRelativeControl = opponent.GetComponent(CameraRelativeControl);
		var opponentVelocity : Vector3 = opponentScript.getVelocity();
		
		// If opponent velocity is greater, push self to opponent's velocity
		if (opponentVelocity.magnitude > character.velocity.magnitude) {
			velocity = opponentVelocity - character.velocity;
		}
		// If current object velocity is greater, push self back
		else {
			velocity = character.velocity * -1;
		}
		
		if (continueOpponent) {
			opponentScript.getHit(this.gameObject, false);
		}
		
		playersAfterHit.Add(opponentName);
		state = PlayerState.Hit;
		StartCoroutine(removePlayerAfterHit(opponentName));
		
	}
}

function removePlayerAfterHit(name : String) {
	yield WaitForSeconds(afterHitDuration);
	removeAfterHit(name);
}

function jump() {
	if (canJump) {
		//velocity = character.velocity;
		velocity.y = jumpSpeed;
		canJump = false;
	}
}

var isPlayingMove = false;

function allowPlayMoveSound() {
	isPlayingMove = true;
	yield WaitForSeconds(moveSound.length);
	isPlayingMove = false;
}

function playerMoving() {
	if (playerModel.animation) {
		playerModel.animation.Play();
	}
	if (audioSource && !isPlayingMove) {
		StartCoroutine(allowPlayMoveSound());
		audioSource.PlayOneShot(moveSound);
	}
}

function processAction() {
	if (state == PlayerState.Simple) {
		
		var actionEffectsVertical = actionEffects.transform.position.y;
		actionEffects.transform.position = this.gameObject.transform.position;
		actionEffects.transform.position.y = actionEffectsVertical;
		actionEffects.transform.rotation = this.gameObject.transform.rotation;
		
		audioSource.PlayOneShot(dashSound);
		actionEffects.Play();
		state = PlayerState.Attacking;
	}
}

function Update()
{

	if (enableKeyboardMovement) {
		// For keyboard testing!
	    if (Input.GetKey("w")) {
	    	moveJoystick.position.y = Mathf.Clamp( 1, moveJoystick.guiBoundary.min.y, moveJoystick.guiBoundary.max.y );
	    }
	    else if (Input.GetKey("s")) {
	    	moveJoystick.position.y = Mathf.Clamp( -1, moveJoystick.guiBoundary.min.y, moveJoystick.guiBoundary.max.y );
	    }
	    else if (Input.GetKey("a")) {
	    	moveJoystick.position.x = Mathf.Clamp( -1, moveJoystick.guiBoundary.min.x, moveJoystick.guiBoundary.max.x );
	    }
	    else if (Input.GetKey("d")) {
	    	moveJoystick.position.x = Mathf.Clamp( 1, moveJoystick.guiBoundary.min.x, moveJoystick.guiBoundary.max.x );
	    }
	    
	    if (Input.GetKey("p")) {
			processAction();
	    }
    }

	if ( actionButton && actionButton.isFingerDown()) {
		processAction();
	}

}