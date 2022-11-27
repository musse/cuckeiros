extends Area2D

signal hit
signal kiss

enum PLAYER_TYPE {LO, CADU, BOB}
var PLAYER_TYPES = PLAYER_TYPE.values()

var TEXTURE_PER_PLAYER_TYPE = {
	PLAYER_TYPE.LO: load("res://images/lo.png"),
	PLAYER_TYPE.CADU: load("res://images/cadu.png"),
	PLAYER_TYPE.BOB: load("res://images/bob.png")
}

var OK_MOB_TYPES_PER_PLAYER_TYPE = {
	PLAYER_TYPE.LO: [Mob.MOB_TYPE.F],
	PLAYER_TYPE.CADU: [Mob.MOB_TYPE.F, Mob.MOB_TYPE.M],
	PLAYER_TYPE.BOB: [Mob.MOB_TYPE.F, Mob.MOB_TYPE.T],
}

var player_type

# How fast the player will move (pixels/sec)
export var speed = 400

# Size of the game window
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# AnimatedSprite.Image.texture = load("res://images/lo.png")
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_position = get_viewport().get_mouse_position()
		velocity = mouse_position - position
	else:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else: 
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		pass
		#$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(mob):
	var ok_mob_types = OK_MOB_TYPES_PER_PLAYER_TYPE[player_type]
	if mob.mob_type in ok_mob_types:
		emit_signal("kiss")
		mob.queue_free()
	else: 
		hide()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disable", true)


func start(pos):
	position = pos
	player_type = PLAYER_TYPES[randi() % PLAYER_TYPES.size()]
	get_node("AnimatedSprite/Image").texture = TEXTURE_PER_PLAYER_TYPE[player_type]
	show()
	$CollisionShape2D.disabled = false
