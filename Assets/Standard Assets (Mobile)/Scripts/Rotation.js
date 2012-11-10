//////////////////////////////////////////////////////////////
// RotationConstraint.js
// Penelope iPhone Tutorial
//
// RotationConstraint constrains the relative rotation of a 
// Transform. You select the constraint axis in the editor and 
// specify a min and max amount of rotation that is allowed 
// from the default rotation
//////////////////////////////////////////////////////////////

enum RotationAxis
{
	X = 0,
	Y,
	Z
}

public var axis : RotationAxis; 			// Rotation around this axis is constrained
public var speed = 0.1;
public var speed2 = 0.1;

function Start()
{
	
}

// We use LateUpdate to grab the rotation from the Transform after all Updates from
// other scripts have occured
function Update() 
{
	Debug.Log("rotating " + this.transform.rotation[axis]);
	transform.Rotate(Vector3.up * Time.deltaTime * speed);
	//transform.Rotate(Vector3.right * Time.deltaTime * speed2);
}
