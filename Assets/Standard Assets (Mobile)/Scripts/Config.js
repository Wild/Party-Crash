#pragma strict

// General variables
public var catastropheChancePercent = 10.0;
public var catastropheAfterEvery = 10.0;

// Effects scripts
public var stormEffectOn = true;

public var stormScript : StormEffect;

//
private var catastrophies : Array;
private var timePassed = 0.0;

class Catastrophe {
	var catastropheScript : ICatastrophe;

  	public function Catastrophe(_catastropheScript : ICatastrophe){
    	this.catastropheScript = _catastropheScript;
	}
}


function Start () {

	addCatastrophies();
}

function Update () {
	timePassed += Time.deltaTime;
	if (timePassed > catastropheAfterEvery) {
		timePassed = 0.0;
		var chance = Random.Range(0.0, 100.0);
		if (chance < catastropheChancePercent && catastrophies.length > 0) {
			var nextCatastropheNumber = Random.Range(0, catastrophies.length);
			var nextCatastrophe : Catastrophe = catastrophies[nextCatastropheNumber];
			//Debug.Log("next catastrophe number! " + nextCatastropheNumber + "TITLE = " + nextCatastrophe.catastropheScript.getTitle());
			
			nextCatastrophe.catastropheScript.startCatastrophe();
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