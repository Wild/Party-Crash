#pragma strict

public var strengthMin = -5.0;
public var strengthMax = 5.0;
public var stormDuration = 10.0;
public var timePassed = 0.0;

private var isStarted = false;

class StormCatastrophe implements ICatastrophe {
	private var stormScript : StormEffect;
	
	public function StormCatastrophe(_stormScript : StormEffect){
		this.stormScript = _stormScript;
	}
	
	function getTitle() {
		return "STORM CATASTROPHE!";
	}
	
	function startCatastrophe () {
		// Storm starting!
		Physics.gravity.x = Random.Range(stormScript.strengthMin, stormScript.strengthMax);
		Physics.gravity.z = Random.Range(stormScript.strengthMin, stormScript.strengthMax);
		stormScript.setIsStarted(true);
	}
}

function Start () {
	
}

function Update () {

	if (!isStarted) {
		return;
	}

	// Play some storm sound...
	timePassed += Time.deltaTime;
	if (timePassed > stormDuration) {
		isStarted = false;
		timePassed = 0.0;
		Physics.gravity.x = 0;
		Physics.gravity.z = 0;
	}
}

function setIsStarted (newIsStarted : boolean) {
	isStarted = newIsStarted;
}