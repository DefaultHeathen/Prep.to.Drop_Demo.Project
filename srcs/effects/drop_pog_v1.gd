extends Node3D
#What makes the door go flying

#func _ready():
#	print($DropPodExportable/Door.global_transform.origin,"|",$DropPodExportable/Door.transform.origin)
#	var tiemr = get_tree().create_timer(18)
#	await tiemr.timeout
#	print($DropPodExportable/Door.global_transform.origin,"|",$DropPodExportable/Door.transform.origin)

func pop():
	print($DropPodExportable/Door.global_transform.origin,"|",$DropPodExportable/Door.transform.origin)
	var new_sfx = AudioStreamPlayer3D.new()
	new_sfx.set_stream(OmniSfx.foley.fart04)
	add_child(new_sfx)
	new_sfx.global_transform.origin = global_transform.origin 
	new_sfx.play(0.0)
#	var new_sfx = get_tree().create_timer(.8)
#	await new_sfx.timeout
#	$DropPodExportable/Door.freeze = false
	await new_sfx.finished
	Omni.player_lock()
	print($DropPodExportable/Door.global_transform.origin,"|",$DropPodExportable/Door.transform.origin)
	print("drop_pog_v1.gd: pop(): DOOR-ING!!")
	$DropPodExportable/Door/DoorEffect.emitting = true
	$DropPodExportable/Door.freeze = false
	$DropPodExportable/Door.call_deferred("apply_central_impulse", Vector3(0,500,500))
	new_sfx.queue_free()
	$Ani.play("Flaps")
	
