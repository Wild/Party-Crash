
enum RotationAxis
{
	X = 0,
	Y,
	Z
}

public var axis : RotationAxis; 			// Rotation around this axis is constrained
public var speed = 0.1;
//public var speed2 = 0.1;

function Start()
{
	
}

function Update() 
{
	transform.Rotate(Vector3.up * Time.deltaTime * speed);
	//transform.Rotate(Vector3.right * Time.deltaTime * speed2);
}
