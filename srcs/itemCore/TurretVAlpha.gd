extends Node3D

var target = null
@export var ammo = 260 #how many shots until it needs to reload... "future proofing" 
@export var in_use = false #in use by player
@export var bullet_spread = 15.0 
@export var firerate = 0.6 #starts firerate_timer on this value
@export var hit_scan = false #is it a bullet or plasma turret
@export var text_out = false #debug reasons
@onready var rcast : RayCast3D = $Head/Barrel/RayCast3D #raycast for line of sight
@onready var firerate_timer = $FireRate #timer, checks if it needs to fire again on .timeout emit().



func _physics_process(delta):
	if target != null:
		look_at(target.global_transform.origin, Vector3.UP, true )
		if rcast.get_collider():
			if (rcast.get_collider().is_in_group("player_body") or rcast.get_collider().is_in_group("targetable")) and firerate_timer.is_stopped():
				fire()




func fire():
	OmniEffects.create_shot(self, rcast, bullet_spread, target, 3, false)
	firerate_timer.start(firerate)
	if text_out:
		print("turretVAlpha.gd: fire(): !")

func _on_area_3d_body_entered(body):
	if (body.is_in_group("player_body") or body.is_in_group("targetable")) and target == null:
		target = body.get_parent()

func _on_area_3d_body_exited(body):
	if target == body.get_parent():
		target == null
