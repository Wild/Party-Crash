#pragma strict

// Effects scripts
public var stormEffectOn = true;

public var stormScript : StormEffect;

function Start () {
	if (stormScript) {
		stormScript.stormEffectOn = this.stormEffectOn;
	}
}

function Update () {

}