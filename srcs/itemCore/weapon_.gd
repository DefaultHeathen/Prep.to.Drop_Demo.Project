extends XRToolsPickable
#20230415T1442; Started randomly late last night

var mag_inserted : bool = true
@export var ammo : int = 60
#@export var muzzle_smoke_timer : float = 4.0 #OmiEffects>create_poof>para:tamount
@export_enum("SMG") var weapon_type : int
@export var bullet_spread : int = 15
@export var firerate = 0.06 #0.06 rd/sec-SMG || Use that dir_export for quick selection
#@export_node_path("AnimationPlayer") var ani
@export_node_path("RigidBody3D") var twohanded_placement #From Mux's own code tutorial found here: https://www.youtube.com/watch?v=BghB0VIgmqU&list=PLe63S5Eft1KaIq9N5PsS5FA3pcLrh686y&index=21 || github pr: https://github.com/BastiaanOlij/godot-vr-weapons/tree/master

#use export_dir to get the proper paths in future class version
@onready var raycast = $PivotPoint/GunCon/ForeGripRoot/RayBeam
@onready var ppoint = $PivotPoint
@onready var ph_node = $PatentedHelperNode
@onready var stock_coll = $PivotPoint/GunCon/StoBone/InteractableSlider/StockSlider/InteractableHandle/CollisionShape3D
@onready var grip_coll = get_node(twohanded_placement).get_node("CollisionShape3D")

signal proxy

var state_flags = {
	cocked = true, #
}

var self_bit = {
	recoil = 0,
	recoil_timer = null,
	recoil_time = .8, #amount of time before gun "settles"
	fr_timer = null,
	mag_mesh = null,
#	gun_basis_redux = null, #used to return the pivotPoint back to "forward";
	#	This issue has eluded me and I had to do this junky code to get it work, Someone PLEASE recommend something better
	#	The gun needs to be rotated but gets all bonkers when I grab it. 
	
}


func _ready():
	self_bit.recoil_timer = $RecoilT
	self_bit.fr_timer = $FirerateT
	self_bit.mag_mesh = $PivotPoint/GunCon/SMGPlayer_V11/MagWellRoot/Mag 
#	ppoint.rotation_degrees.y -= 90 #this has go right when onehanded
#	ppoint.rotation_degrees.y += 90
#	self_bit.gun_basis_redux = ppoint.transform.basis #just this: this goes right when onehanded
	#having nothing causes the gun to stay in place; false being commented out
	
	
	for child in get_children():
		var grab_point := child as XRToolsGrabPoint
		if grab_point:
			_grab_points.push_back(grab_point)
			
#	var thesenuts = get_tree().create_timer(2.0)
#	await thesenuts.timeout
#	fire()



func _on_action_pressed(pickable):
#	print("weapon_.gd: trigger pulled! A: ", ammo, " | w_type: ", weapon_type)
#	ani.play("TriggerFull") #shitty and bad
	if ammo <= 0:
		OmniSfx.createsfx(2, self, false, null)
		return
	call_deferred("fire")
#	if 
	

func fire():
	ammo -= 1
	match weapon_type:
		0:
			#need a small system to account for recoil
			#dynamic float values may be needed
			randomize()
#			var fate_z = randi() % (bullet_spread * 20) + bullet_spread * 10 #1 - 150
			var fate_z = randi_range( #need negative values to "swing" back and forth from.
				-(bullet_spread + self_bit.recoil) * 10, 
				(bullet_spread + self_bit.recoil) * 10)
			fate_z = fate_z/10.0 #.1 - 15.0
			var fate_y = randi_range(
				-(bullet_spread + self_bit.recoil) * 10, 
				(bullet_spread + self_bit.recoil) * 10)
			fate_y = fate_y/10.0 #.1 - 15.0
#			print("weapon_.gd: fire(): fate_z SHOULD be a float of some sort ", fate_z, " | pre ",temp_var)

			print("weapon_.gd: fire(): !")
			#This may change to be ""more realistic"" but 
			OmniSfx.createsfx(0, Omni.player_node.get_node("XRCamera3D"), true, Omni.player_node.global_transform.origin)
			
			
#	return
	if raycast.is_colliding():
#		var coll_group = raycast.get_collider(). #the who
		var coll_mask = raycast.get_collider().get_collision_layer() #the who... collision
		match coll_mask:
			2: #ground, sparks!
#				print("weapon_.gd: fire(): raycast colliding(): hitter: ", raycast.get_collider())
				OmniEffects.create_poof(1, self, true, raycast.get_collision_point())
	match ammo <= 0:
		true:
			mag_magnet_toggle()
		false:
			self_bit.recoil += 1
			self_bit.recoil_timer.start(self_bit.recoil_time)
			self_bit.fr_timer.start(firerate)


func _on_recoil_timeout():
	print("recoil_timeout")
	self_bit.recoil = 0


func _on_firerate_timeout():
#	print("firerate_timeout")
	if by_controller:
		if by_controller.is_button_pressed("trigger_click"):# and ammo > 0:
#			print("trigger held, AUTOMATIC FIRE")
			if ammo > 0:
				fire()


func _on_picked_up(pickable):
	#promo demo stuff; set by ODST_core.gd autoload
	emit_signal("proxy", 2) #calls Omni.ODST.gd.ani_get_down(2); the 2 being the added parameter that goes through
	
	print("weapon_.gd: _on_pick_up")
	stock_coll.disabled = false
	grip_coll.disabled = false
#	$CollisionShape3D.rotation_degrees.y = 90
#	by_controller.button_pressed.connect(temp_noti_func) #prints controller input

#func temp_noti_func(_null):
	#prints controller input
#	print("controller input: ", _null)

func mag_magnet_toggle():
	#needs arg, too open ended to be "safe"
	print("magnet")
	match mag_inserted:
		false:
			print("weapon_.gd: mag_magnet(mag_inserted = true): ")
			mag_inserted = true
			self_bit.mag_mesh.show()
		true:
			print("weapon_.gd: mag_magnet(mag_inserted = false): ")
			mag_inserted = false
			self_bit.mag_mesh.hide()
			var not_clip = OmniLoader.create_item(0, get_parent(), ammo, self.global_transform.origin)

func _on_mag_area_body_entered(body):
	if body.is_in_group("Mag") and mag_inserted:
		body.ammo_can = ammo
		print("weapon_.gd(): mag_body_ent(): SaM 'reload'")
		mag_magnet_toggle()
		

func _physics_process(delta):
	#there's probably a good reason why the orignal code asked for a regular _process()
	
	#passive code for having smooth recoil dissipation, Tween wouldn't work on the fire() call mainly because it sounds like a bad idea. Worse, if here.
	#	would it be better to have here or after the "aiming" block?
	
	match get_node(twohanded_placement).is_picked_up():
		true:
#			ppoint.look_at(ph_node.global_transform.origin, global_transform.basis.y)
			
#		false:
#			pass
	

#	if twohanded.is_picked_up():
##		$Pivot/GunHand.visible = true
			var target = get_node(twohanded_placement).global_transform.origin + (global_transform.basis.y * ppoint.transform.origin.y) #perfect! not sure why I tried the next one
#			var target = get_node(twohanded_placement).by_controller.get_node("PalmPoint").global_transform.origin + (global_transform.basis.y * ppoint.transform.origin.y) 
			#not using the patented helper node and using the grip, which following the hand, and the grip in the above line.
			#	causes the gun to move all wonky when the player moves around
#			var target = ph_node.global_transform.origin + (global_transform.basis.y * ppoint.transform.origin.y) #does one handed thing, but 90 deg right #does the one-handed-dual-grip thing straight ahead when look_at is gone (WHEN LOOK_AT IS GONE)
			ppoint.look_at(target, global_transform.basis.y)
#	else:vot/GunHand.visible = false
		false:
#			ppoint.transform.basis = self_bit.gun_basis_redux
#			ppoint.rotation_degrees.y = 90 #this aims left when one handed
#			ppoint.rotation_degrees.y = -90 #This aims right when one handed
			ppoint.transform.basis = Basis() #oh, I guess something else broke it



func _on_mag_release_butt_body_entered(body):
	pass # Replace with function body.


func _on_dropped(pickable):
	stock_coll.disabled = true
	grip_coll.disabled = true
	pass
