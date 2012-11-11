#pragma strict

enum CatastropheState { None, Incoming }

// General variables
public var loadingTexture : Texture2D;
public var catastropheChancePercent = 10.0;
public var catastropheAfterEvery = 10.0;
public var timeBeforeCatastropheStart = 3.0;

// Effects scripts
public var stormEffectOn = true;

public var stormScript : StormEffect;

//
private var isLoaded = false;
private var catastrophies : Array;
var timePassed = 0.0;
private var incomingCatastrophe : ICatastrophe;
private var state = CatastropheState.None;

class Catastrophe {
	var catastropheObject : ICatastrophe;

  	public function Catastrophe(_catastropheObject : ICatastrophe){
    	this.catastropheObject = _catastropheObject;
	}
}


function Start () {
	addCatastrophies();
}

function OnGUI() {
	if (!isLoaded) {
		//if (GUI.Button(Rect(0, 0, Screen.width, Screen.height), "Loading scene..!")) {
		if (GUI.Button(Rect(0, 0, Screen.width, Screen.height), loadingTexture)) {
			Debug.Log("STARTING!");
		}
	}
	
	if (state == CatastropheState.Incoming) {
		var width = 500;
		var height = 300;
		
		var timeLeft = Mathf.Round((timeBeforeCatastropheStart - timePassed) * 100) / 100;
		var message = incomingCatastrophe.getTitle() + " in " + timeLeft + "!";
		GUI.Label(Rect((Screen.width - width) / 2, (Screen.height - height) / 2, width, height), message);
	}
}

function Update () {
	
	// Later change to when camera position set, that's when scene is loaded
	if (!isLoaded) {
		timePassed += Time.deltaTime;
		if (timePassed > 3.0) {
			isLoaded = true;
		}
	}
	
	switch (state) {
		case CatastropheState.None :
			waitingForCatastrophe();
			break;
		case CatastropheState.Incoming :
			preparingForCatastrophe ();
			break;
	}

}

function preparingForCatastrophe () {
	timePassed += Time.deltaTime;
	if (timePassed > timeBeforeCatastropheStart) {
		timePassed = 0.0;
		incomingCatastrophe.startCatastrophe();
		state = CatastropheState.None;
	}
}

function waitingForCatastrophe () {
	timePassed += Time.deltaTime;
	if (timePassed > catastropheAfterEvery) {
		timePassed = 0.0;
		var chance = Random.Range(0.0, 100.0);
		if (chance < catastropheChancePercent && catastrophies.length > 0) {
			var nextCatastropheNumber = Random.Range(0, catastrophies.length);
			var nextCatastrophe : Catastrophe = catastrophies[nextCatastropheNumber];
			
			state = CatastropheState.Incoming;
			incomingCatastrophe = nextCatastrophe.catastropheObject;
		}
	}
}

function addCatastrophies () {
	catastrophies = new Array();
	
	// Initialize activated catastrophies and add to array
	if (stormEffectOn) {
		var stormCatastrophe = new StormCatastrophe(stormScript);
		catastrophies.push(new Catastrophe(stormCatastrophe));
	}
}