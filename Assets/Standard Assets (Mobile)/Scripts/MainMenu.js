#pragma strict

var startGameSceneName = "CameraRelativeSetup";
var timeSpent = 0.0;
private var nextSceneChosen = false;

function Start () {

}

function Update () {
	
	if (!nextSceneChosen) {
		return;
	}
	
	timeSpent += Time.deltaTime;
	if (timeSpent >= 3.0){
		timeSpent = 0.0;
		Destroy(gameObject);
	}

}

function OnGUI() {

	var width = Screen.width / 3;
	var height = Screen.height / 6;
	var paddingTop = Screen.height / 8;

	if (GUI.Button(Rect((Screen.width - width) / 2, paddingTop, width, height), "Start Game!")) {
		nextSceneChosen = true;
		Application.LoadLevel(startGameSceneName);
	}
}
