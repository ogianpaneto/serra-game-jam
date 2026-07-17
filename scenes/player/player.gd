extends CharacterBody2D


@export var speed = 500
@export var dodge_speed = 1500
@export var dodge_cooldown = 0.5

@onready var weapon: Weapon = $WeaponHolder/Handgun
@onready var animated_sprite = $AnimatedSprite2D
@onready var dodge_timer = $DodgeTimer
@onready var dodge_cooldown_timer = Timer.new()

var is_invulnerable = false
var is_dodging = false
var can_dodge = true
var dodge_direction = Vector2.ZERO

func _ready() -> void:
	add_child(dodge_cooldown_timer)
	dodge_cooldown_timer.one_shot = true
	dodge_cooldown_timer.timeout.connect(_on_dodge_cooldown_timer_timeout)
	

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# Player movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Animation
	if get_global_mouse_position().x < global_position.x:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
		
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	
	# Dodging
	if can_dodge and direction != Vector2.ZERO and Input.is_action_just_pressed("dodge"):
		dodge(direction)
	if is_dodging:
		velocity = dodge_direction * dodge_speed
	else:
		velocity  = direction * speed
	
	move_and_slide()

func _process(_delta: float) -> void:
	weapon.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("atack"):
		weapon.fire()
	
func dodge(direction):
	is_invulnerable = true
	is_dodging = true
	can_dodge = false
	dodge_direction = direction.normalized()
	dodge_timer.start()

func _on_dodge_timer_timeout():
	is_invulnerable = false
	is_dodging = false
	dodge_cooldown_timer.start(dodge_cooldown)

func _on_dodge_cooldown_timer_timeout():
	can_dodge = true
