#pragma strict

function OnTriggerEnter (other : Collider) {
    if (other.gameObject.name == "Player") {
    	var control = other.gameObject.GetComponent(CameraRelativeControl);
    	var respawnPoint : Vector3 = control.getRespawnPoint();
    	other.gameObject.transform.position = respawnPoint;
    }
}