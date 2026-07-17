extends Area2D


@export var speed := 2000
@export var lifetime := 2.0
@export var damage := 10

func _ready() -> void:
	body_entered.connect(_on_hit)
	area_entered.connect(_on_hit)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func set_damage(value: int) -> void:
	damage = value


func _on_hit(_other: Node) -> void:
	if _other.has_method("take_damage"):
		_other.call("take_damage", damage)
	queue_free()
