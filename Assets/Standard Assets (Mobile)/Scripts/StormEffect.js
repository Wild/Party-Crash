#pragma strict

public var stormEffectOn = false;
public var strengthMin = -5.0;
public var strengthMax = 5.0;
public var weatherChangeDelay = 10.0;
public var chanceForStormPercent = 10.0;
public var timePassed = 0.0;

function Start () {
	
}

function Update () {
	// Play some storm sound...
	timePassed += Time.deltaTime;
	if (timePassed > weatherChangeDelay) {
		timePassed = 0.0;
		var chance = Random.Range(0.0, 100.0);
		if (chance < chanceForStormPercent) {
			// Storm starting!
			Physics.gravity.x = Random.Range(strengthMin, strengthMax);
			Physics.gravity.z = Random.Range(strengthMin, strengthMax);
		}
		else {
			Physics.gravity.x = 0;
			Physics.gravity.z = 0;
		}
	}
}