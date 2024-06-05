extends CSGCylinder3D

@export_category("Properties")
@export var tag : String = "entity"
@export var randomMovement : bool = false

var lookable = true

var rng = 0

func _ready():
	randomize()
	rng = randf_range(-2.5, 2.5)

func _process(delta):
	if randomMovement:
		translate(Vector3(rng,0,rng)*delta)
