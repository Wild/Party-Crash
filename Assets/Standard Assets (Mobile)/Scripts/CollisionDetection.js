#pragma strict

function OnTriggerEnter (other : Collider) {
    if (other.gameObject.name == "PlayerCollider") {
    	var opponentObject = other.gameObject.transform.parent.gameObject;
    	if (opponentObject != this.gameObject) {
    		this.gameObject.GetComponent(CameraRelativeControl).getHit(opponentObject, true);
    	}
    }
}