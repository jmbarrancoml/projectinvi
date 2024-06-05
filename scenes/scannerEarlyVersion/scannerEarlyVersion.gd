extends Node3D

@export_group("Scanning Timer")
@export var scanningTimer : Timer
@export_group("Variables")
@export var scanningDistance : float = 25
@export var detectableObjects : String
@export var scannerScale : int = 5
@export_group("Player")
@export var player : CharacterBody3D

@onready var detectionCollider : CollisionShape3D = $"detectionArea/detectionCollider"
@onready var detectionArea : Area3D = $"detectionArea"
@onready var scannerDot : Node3D = $"scannerVisuals/ScannerDot"
@onready var scannerDotInstance = load("res://scenes/scannerEarlyVersion/scannerDot.tscn")
@onready var scannerDots : Array[Dictionary]

func _ready():
	detectionCollider.shape.radius = scanningDistance
	scanningTimer.start()
	detectionArea.global_position = player.global_position
	pass
	
func _process(delta):
	if checkTimer():
		# Obtener todos los objetos en el radio de 10
		var overlappingBodies = detectionArea.get_overlapping_bodies()
		print("Overlapping bodies:", overlappingBodies)
		print("Checking bodies...")
		for body in overlappingBodies:
			if checkBody(body):
				print("Body %s is an entity and his coords are %s" % [body.name, body.position])
				if not checkIfBodyAlreadyInScannerDots(body):
					var new_scanner_dot_instance = scannerDotInstance.instantiate()
					updateScannerDotFromBody(body, new_scanner_dot_instance)
					$scannerVisuals.add_child(new_scanner_dot_instance)
					scannerDots.append({
						"name": body.name,
						"scannerDotInstance": new_scanner_dot_instance
					})
				else:
					var dot = searchInScannerDots(body)
					updateScannerDotFromBody(body, dot)
				print("Scanner dots %s " % [scannerDots])
	pass

func checkTimer():
	"""
	Devuelve true si el timer se ha acabado, false si no
	"""
	if scanningTimer.is_stopped():

		scanningTimer.start()
		return true
	else:
		return false
		
func checkBody(body : Node3D):
	print("Checking body %s " % [body.name])
	if body.is_in_group("entity"):
		return true
	else:
		return false
		
func computeBodyRelativeCoords(body : Node3D):
	# First we get the relative direction
	var direction =  body.global_position - player.global_position
	print("Scanner coords are %s " % [player.global_position])
	print("Body coords are %s " % [body.global_position])
	print("Scanner rel coords are %s " % [player.position])
	print("Body coords rel are %s " % [body.position])	
	print("The direction of the vector is %s" % [direction])
	var new_x = scannerDot.position.x + (direction.x / scannerScale)
	var new_y = scannerDot.position.y - (direction.z / scannerScale)
	var new_z = scannerDot.position.z
	return Vector3(new_x, new_y , new_z)
	
func updateScannerDotFromBody(body : Node3D, scannerDotInstance: Node3D):
	var coords = computeBodyRelativeCoords(body)
	scannerDotInstance.position = coords
	scannerDotInstance.playPulseAnimation()
	print("Updating coords to %s " % [coords])
	print("Scanner dot coords are %s " % [scannerDotInstance.global_position])
	print("Scanner dot rel coords are %s " % [scannerDotInstance.position])	
	print("Scanner dot parent %s " % scannerDot.get_parent().name)

func checkIfBodyAlreadyInScannerDots(body : Node3D):
	for dot in scannerDots:
		if dot["name"] == body.name:
			return true
	return false
	
func searchInScannerDots(bodyToSearch : Node3D):
	for dot in scannerDots:
		if dot["name"] == bodyToSearch.name:
			return dot["scannerDotInstance"]
	return null

func updateScannerRotation(new_rotation_y):
	$scannerVisuals.rotation.z = - new_rotation_y
	

func _on_detection_area_body_exited(body):
	if not checkBody(body):
		return
	var detected_dot = deleteInScannerDots(body)
	if detected_dot == null:
		return
	
func deleteInScannerDots(bodyToDelete : Node3D):
	var index = 0
	for dot in scannerDots:
		if dot["name"] == bodyToDelete.name:
			dot["scannerDotInstance"].queue_free()
			scannerDots.remove_at(index)
			return true
		index += 1
	return false
