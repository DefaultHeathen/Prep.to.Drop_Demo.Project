extends XRToolsPickable
#20230713T1448; this is a complete rip from Mr. Bastiaans's own TwoHanded script from his yt video project files
# https://www.youtube.com/watch?v=BghB0VIgmqU 
# https://github.com/BastiaanOlij/godot-vr-weapons/tree/master > models > sniper > ???? > golden code!
# ---- Need to add in the ability to hold the gun by the grip lol ---- 

var _rot_deg = {  #allows extra things to return to original position; be mindful when changing nodes
	og_grip = null,
	og_hand_l = null,
	og_hand_r = null,
	}
	

@onready var right_mesh = get_parent().get_node("HandR")
@onready var left_mesh = get_parent().get_node("HandL")

# the first idea; Doesn't work with tween and wondering why
#@export var folded_out_transform : Transform3D 
#@export var right_fo_transform: Transform3D 
#@export var left_fo_transform: Transform3D 

@export var folded_out_rot : Vector3 #use gimme_that_transfrom.gd on the grip mesh, if applicable
@export var right_fo_rot: Vector3 #same with the grip but for both hands. 
@export var left_fo_rot: Vector3 #There's an obvious faster solution to this, I'm sure.


@export_node_path("RigidBody3D") var weapon_root 
@export_node_path("Node3D") var grip_root #Much easier if the mesh is child of a Node3D;
#	In this case, "ForeBone" will work.
#	One can also just attach the HandL/R to the grip_root/our ForeBone node, set the position to 
#		work in both un/folded pos, skipping the legwork, but I'm here to learn!

func _ready():
	super()
	set_enabled(enabled)
	
#	if get_node(grip_root):
#		_transforms.og_grip = get_node(grip_root).transform
#	_transforms.og_hand_l = left_mesh.transform
#	_transforms.og_hand_r = right_mesh.transform
	if get_node(grip_root):
		_rot_deg.og_grip = get_node(grip_root).rotation_degrees
	_rot_deg.og_hand_l = left_mesh.rotation_degrees
	_rot_deg.og_hand_r = right_mesh.rotation_degrees

func set_enabled(new_enabled):
	enabled = new_enabled
	
	if is_picked_up() and !enabled:
		let_go()
	
#	if $CollisionShape3D:
#		$CollisionShape3D.disabled = !enabled

func pick_up(by, with_controller):
	print("weapon_grip.gd: pick_up(): fired")
	if get_node(weapon_root).is_picked_up():
		super(by, with_controller) #no idea if this is right/"proper"
		print("weapon_grip.gd: pick_up(): picked_up_by: ", picked_up_by," ||| ", with_controller.tracker)
	#	var hand = picked_up_by.get_hand() #changed from picked_up_by.get_hand() #actually, the new xrTools covers it
		if by_hand.visible:
			match with_controller.tracker:
	#		match str(with_controller.tracker):
				"left_hand":
					left_mesh.show()
				"right_hand":
					right_mesh.show()
			by_hand.hide()
#			by_controller.transform.origin += (by_controller.global_transform.origin - global_transform.origin) #bad idea
	


func let_go(starting_linear_velocity = Vector3(0.0, 0.0, 0.0), p_angular_velocity = Vector3()):
	print("weapon_grip.gd: let_go(): fired!")
	if picked_up_by:
		if !by_hand.visible: #hope this is fine lol
			left_mesh.hide()
			right_mesh.hide()
			by_hand.show()
#			by_controller.global_transform.origin = Vector3()
			by_controller.transform.origin = Vector3()
		transform.origin = Vector3()
		rotation_degrees = Vector3()
	print("weapon_grip.gd: let_go(): last check picked_up_by: ", picked_up_by)
	super(starting_linear_velocity, p_angular_velocity)


func _on_action_pressed(pickable):
	#if you just attach the mesh to the 'Forebone' node,
	#	just show()/hide() the proper mesh and
	#	you can scratch the second match block.
	print("weapon_grip.gd: trigger pulled: match THIS!! ", get_node(grip_root).rotation_degrees == _rot_deg.og_grip)
	match get_node(grip_root).rotation_degrees == _rot_deg.og_grip:
		true:
			print("weapon_grip.gd: action_pressed(): true!")
			var grip_tween = get_tree().create_tween()
			grip_tween.set_parallel(true)
			var hand_tween = get_tree().create_tween()
			hand_tween.set_parallel(true)
#			grip_tween.tween_property(get_node(grip_root), "transform", folded_out_transform, .8) #this did nothing
			grip_tween.tween_property(get_node(grip_root), "rotation_degrees", folded_out_rot, .8)
			match by_controller.tracker:
				"left_hand":
					hand_tween.tween_property(left_mesh, "rotation_degrees", left_fo_rot, .8)
				"right_hand":
					hand_tween.tween_property(right_mesh, "rotation_degrees", right_fo_rot, .8)
		false:
			print("weapon_grip.gd: action_pressed(): false!")
			var grip_tween = get_tree().create_tween()
			grip_tween.set_parallel(true)
			var hand_tween = get_tree().create_tween()
			hand_tween.set_parallel(true)
			grip_tween.tween_property(get_node(grip_root), "rotation_degrees", _rot_deg.og_grip, .8)
#			grip_tween.tween_property(get_node(grip_root), "transform", _transforms.og_grip, .8)
			match by_controller.tracker:
				"left_hand":
					hand_tween.tween_property(left_mesh, "rotation_degrees", _rot_deg.og_hand_l, .8)
				"right_hand":
					hand_tween.tween_property(right_mesh, "rotation_degrees", _rot_deg.og_hand_r, .8)
