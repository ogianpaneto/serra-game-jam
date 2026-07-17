extends CharacterBody2D
class_name Enemy


@export var max_health: int = 20
@export var move_speed: float = 80.0

var health: int


func _ready() -> void:
	health = max_health


func _physics_process(_delta: float) -> void:
	var player := get_tree().current_scene.get_node_or_null("Player") as Node2D
	if player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	move_and_slide()

	if has_node("Sprite2D"):
		($Sprite2D as Sprite2D).flip_h = direction.x < 0


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
