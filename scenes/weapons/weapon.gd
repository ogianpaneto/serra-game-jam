extends Node2D
class_name Weapon


@export var damage: int = 10
@export var fire_rate: float = 0.3
@export var bullet_scene: PackedScene = preload("res://scenes/weapons/bullet/bullet.tscn")

@onready var muzzle: Marker2D = $Muzzle

var can_fire: bool = true


func fire():
	if !can_fire:
		return
	
	can_fire = false
	shoot()
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func shoot():
	var bullet = bullet_scene.instantiate()
	var bullet_node := bullet as Node2D


	bullet_node.global_position = muzzle.global_position if muzzle != null else global_position
	bullet_node.global_rotation = global_rotation

	if bullet.has_method("set_damage"):
		bullet.call("set_damage", damage)
	elif "damage" in bullet:
		bullet.damage = damage

	get_tree().current_scene.add_child(bullet_node)
