#pragma strict

var clouds1 : Transform;
var clouds2 : Transform;
var speedMin = 2.5;
var speedMax = 20.0;

private var speed1 = 0.0;
private var speed2 = 0.0;

function Start () {
	speed1 = Random.Range(speedMin, speedMax);
	speed2 = Random.Range(speedMin, speedMax);
}

function Update () {

	if (clouds2.position.x < clouds2.localScale.x * (-2.5)) {
		clouds2.position.x = clouds2.localScale.x * 2;
		speed2 = Random.Range(speedMin, speedMax);
	}
	else if (clouds1.position.x < clouds1.localScale.x * (-1.0)) {
		var tempClouds = clouds1;
		clouds1 = clouds2;
		clouds2 = tempClouds;
		
		var tmpSpeed = speed1;
		speed1 = speed2;
		speed2 = tmpSpeed;
	}
	clouds1.position.x -= speed1 * Time.deltaTime;
	clouds2.position.x -= speed2 * Time.deltaTime;
}