extends RigidBody2D
class_name Mob

enum MOB_TYPE {M, F, T}
var MOB_TYPES = MOB_TYPE.values()

var TEXTURE_PER_MOB_TYPE = {
	MOB_TYPE.M: load("res://images/cr.png"),
	MOB_TYPE.F: load("res://images/anitta.png"),
	MOB_TYPE.T: load("res://images/pablo.png")
}

var mob_type

func _ready():
	$AnimatedSprite.playing = true
	mob_type = MOB_TYPES[randi() % MOB_TYPES.size()]
	$Image.texture = TEXTURE_PER_MOB_TYPE[mob_type]

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
