#pragma strict

enum CameraPosition { Top, Side }

var positionTop : Transform;
var positionSide : Transform;
var ground : Transform;
var transitionSpeed = 0.1;
var cameraChangeSound : AudioClip;
var audioSource : AudioSource;

var cameraPosition : CameraPosition;

var startPosition = Vector3.zero;
var endPosition = Vector3.zero;

function SetPosition(newPosition : Transform) {
	endPosition = newPosition.position;
	startPosition = transform.position;
	
	//this.gameObject.transform.position = newPosition.position;
	//this.gameObject.transform.rotation = newPosition.rotation;
}

function Start () {
	cameraPosition = CameraPosition.Side;
	SetPosition(positionSide);
}

function Update () {
	
	if (Vector3.Distance(transform.position, endPosition) > 0.01) {
		transform.position = Vector3.Lerp(transform.position, endPosition, transitionSpeed);
		FaceCameraToGround();
	}
}

function OnGUI() {
	if (this.camera.enabled) {
		if (GUI.Button(Rect(400, 10, 200, 100), "Toggle camera")) {
		
			if (cameraChangeSound) {
				audioSource.PlayOneShot(cameraChangeSound, 1);//AudioSource.PlayClipAtPoint(cameraChangeSound, transform.position);
			}
			
			if (cameraPosition == CameraPosition.Top) {
				cameraPosition = CameraPosition.Side;
				SetPosition(positionSide);
			}
			else {
				cameraPosition = CameraPosition.Top;
				SetPosition(positionTop);
			}
		}
	}

}

function FaceCameraToGround() {
	transform.LookAt(ground.position);
}