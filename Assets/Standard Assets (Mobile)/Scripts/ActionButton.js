#pragma strict

//RequireComponent( GUITexture )

private var gui : GUITexture;
private var lastFingerId = -1;
private var canAttack = true;
private var actionDelay = 2.0;

function Start () {
	gui = GetComponent( GUITexture );
	gui.color = Color.white;
	//renderer.material.SetFloat("_Cutoff", Mathf.InverseLerp(0, Screen.width, Input.mousePosition.x));
}

public function isFingerDown () : boolean {
	return (lastFingerId != -1);
}

function allowAttackAfterDelay() {
	gui.color = Color.red;
	canAttack = false;
	yield WaitForSeconds(actionDelay);
	canAttack = true;
	gui.color = Color.white;
}

function Update () {
	
	//gui.renderer.material.SetFloat("_Cutoff", Mathf.InverseLerp(0, Screen.width, Input.mousePosition.x));
	
	if (!canAttack) {
		lastFingerId = -1;
		return;
	}
	
	var count = Input.touchCount;
	
	if (count == 0) {
		lastFingerId = -1;
	}
	else {
		for(var i : int = 0; i < count; i++) {
			var touch : Touch = Input.GetTouch(i);
			
			if (touch.phase == TouchPhase.Began && gui.HitTest(touch.position) ) {
				StartCoroutine(allowAttackAfterDelay());
				lastFingerId = touch.fingerId;
			}
			else {
				lastFingerId = -1;
			}
		}
	}
}

public function setActionDelay (newActionDelay) {
	actionDelay = newActionDelay;
}