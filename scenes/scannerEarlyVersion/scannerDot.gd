extends Node3D

@export_category("Appearance")
@export var color: Color

@export_category("Variables")
@export var isPlayer : bool

@export_category("Animations")
@export var pulseAnimation : AnimationPlayer

@onready var sprite = $Sprite3D

func _ready():
	sprite.modulate = color

func playPulseAnimation():
	if not isPlayer:
		pulseAnimation.play("pulse")
