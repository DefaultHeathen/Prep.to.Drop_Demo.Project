extends Node
#20230415T1526;

#This autoload holds, creates and deletes needed effects. 
#	Which usually call OmniSfx and OmniLoader items to complete the "smoke and mirror"

var poofs = {
	gen_poof = null, #generic placholder ground impact poof
	smg_shot = null, #smg_muzzle_flash (needs to be replaced)
	alien_med = null, #medium alien muzzle flash, 
	plasma_exp_med = null, #mediuim alien explosion 
}

#effects
#src is named after them so OmniEffects.effects seemed odd
var blud_1_ = null

var world_e = { #world environments
	pastel = load("res://assets/3D/res/WE/Preloading.tres"),
	nemombasa = load("res://assets/3D/res/WE/NMombasaTypeBeat_V1.tres"),
}

var projectiles = { #phyiscal bullets, shots, grenades, whatever
	plasma_med_large = load("res://scenes/effects/PlasmaShotMedLargeV01.tscn")
}

func _ready():
	poofs.gen_poof = load("res://scenes/effects/f_w_impact_v1.5.tscn")
	poofs.smg_shot = load("res://scenes/effects/smoke_smg.tscn")
	poofs.alien_med = load("res://scenes/effects/plasma_muzz_medv01.tscn")
	poofs.plasma_exp_med = load("res://scenes/effects/plasma_exp_medV01.tscn")
	
	blud_1_ = load("res://scenes/effects/f_w_impact_v1.5.tscn")


func create_poof(type: int, des_node, p_loc_0:bool, p_loc): #wait some calls are for the rqe_sfx are bool and int, the hell???
	#example use:
	#	OmniEffects.create_poof(1, self, false, true, raycast.get_collision_point())
	
	#type: of effect requested
	#des_node: what node to use as parent; preferably a Node3D
	#p_loc: placing at the end of the of raycast
	#p_loc: the vector3(),
	#	not hinted since it's ""cleaner"" to see null, than Vector(), 
	#	change as you will
	
	var tamount
	var poof_ = null
	var emitter: CPUParticles3D = null
	
	match type:
		0: #smg_shot muzzle flash
			poof_ = poofs.smg_shot.instantiate()
			emitter = poof_.get_node("MuzzleEffectPlayer")
			tamount = 4.0
			OmniSfx.createsfx(0, des_node, true, des_node.global_transform.origin)
			
		1: #ground/wall impact
			poof_ = poofs.gen_poof.instantiate()
			emitter = poof_.get_node("FWImpactV15_")
			tamount = 2.0
			OmniSfx.createsfx(69, des_node, true, des_node.global_transform.origin) #placeholder
			
#		2: #another smg for some reason
#			poof_ = poofs.null.instantiate()
#			emitter = poof_.get_node("null")
#			tamount = 4.0
		
		3: #plasma turret muzzle flash
			poof_ = poofs.alien_med.instantiate()
			emitter = poof_.get_node("MuzzleEffectPlayer")
			tamount = 4.0
			OmniSfx.createsfx(69, des_node, true, des_node.global_transform.origin) #placeholder
			
		4: #plasma turret shot hit
			poof_ = poofs.plasma_exp_med.instantiate()
			emitter = poof_.get_node("ExpEffect")
			tamount = 4.0
			OmniSfx.createsfx(69, des_node, true, des_node.global_transform.origin) #placeholder
			
		
	des_node.get_parent().add_child(poof_)
	
	
	if p_loc_0:
		poof_.global_transform.origin = p_loc
	else:
		poof_.global_transform.origin = des_node.global_transform.origin
		
	
	poof_.scale = Vector3(1, 1, 1)
	emitter.scale = Vector3(1, 1, 1)
	
#	print("OmniEffects.gd: emitter: ", emitter)
	emitter.emitting = true
	
	
	var tttimer = get_tree().create_timer(tamount)
	await tttimer.timeout
	if is_instance_valid(poof_):
		poof_.queue_free()


func create_shot(start_point_node, users_raycast, bullet_spread, target, round_type: int, hit_scan: bool):
#	start_point_node: if a Rigidbody3d Node is needed, like a plasma shot, this will place it appropriately 
#	users_raycast: the actual raycast node of a weapon, turret, etc. Checks collsion and calls proper hits.
#	bullet_spread: inputted weapons bullet spread. (remove and just get it from user_raycast parent().bullet_spread or something)
#	target: uses this nodes' global_transform.origin, but it usually aims at the ground. (quickly tween 'up' of origin? call func attempt_shot()??)
#	round_type: what type of shot is being created
#	hit_scan: bullet or slower? should be able to infer from round_type (remove and do <-- that)
#	
#	Currently a hitscan and regular bullet func. Might seperate to make them easir to use/understand
#	Mainly done to avoid effects disappearing half way through. 
#	example func use:
#		OmniEffects.create_shot(self, rcast, bullet_spread, target, 3, false) #used to create a plasma turret shot
	
	randomize() #don't need this I think
#			var fate_z = randi() % (bullet_spread * 20) + bullet_spread * 10 #1 - 150
	var fate_z = randi_range( #need negative values to "swing" back and forth from.
		(-1 * bullet_spread) * 5, 
		bullet_spread * 10)
	fate_z = fate_z/10.0 #.1 - 15.0
	var fate_y = randi_range(
		(-1 * bullet_spread) * 5, 
		bullet_spread * 10)
	fate_y = fate_y/10.0
#	OmniEffects.create_poof(0, self, false, false, null)
	match hit_scan:
		true:
			var aim_point_v1 = target.global_transform.origin + Vector3(0, 1.0, 0)
			var dir_to = users_raycast.global_transform.origin.direction_to(aim_point_v1)
		#		dir_to = rcast.global_transform.origin.direction_to(bag.last_saw)
			users_raycast.global_transform.basis = Basis(dir_to.cross(Vector3.UP), Vector3.UP, dir_to)
			if users_raycast.is_colliding():
				var coll_mask = users_raycast.get_collider().get_collision_layer() #the who... collision
				
				match coll_mask:
					2: #ground, sparks!
						create_poof(1, self, true, users_raycast.get_collision_point())
					6:
						create_poof(1, self, true, users_raycast.get_collision_point())
				if users_raycast.get_collider().is_in_group("AI"):
					pass
			
			
	#	shot_line(rcast.global_transform.origin, rcast.get_collision_point()) #original working func
			var line_maker = ImmediateMesh.new()
			var line = MeshInstance3D.new()
			var line_mat = StandardMaterial3D.new()
			line_mat.albedo_color = Color.GOLDENROD
			line_maker.surface_begin(Mesh.PRIMITIVE_LINES, line_mat)
			line_maker.surface_add_vertex(users_raycast.global_transform.origin)
			line_maker.surface_add_vertex(users_raycast.get_collision_point())
			line_maker.surface_end()
			line.mesh = line_maker
			line.cast_shadow = false
			get_tree().get_root().add_child(line)
			line.scale = Vector3(1, 1 , 1)
			var timer = get_tree().create_timer(.4)
			await timer.timeout
			line.queue_free()
			
		false:
			var plasma_shot_ = null
			match round_type:
				3: #plasmaMedLarge
					plasma_shot_ = projectiles.plasma_med_large.instantiate()
					start_point_node.get_parent().get_parent().get_parent().get_parent().add_child(plasma_shot_)
#					plasma_shot_.global_transform.origin = users_raycast.global_transform.origin #becomes all wonky when angled up/down
					plasma_shot_.global_transform.origin = start_point_node.global_transform.origin
					plasma_shot_.rotation_degrees = start_point_node.rotation_degrees
					plasma_shot_.get_node("Base/Trail/TEffect").emitting = true
					plasma_shot_.get_node("Base").set_process(true)
					
			

	create_poof(round_type, self, true, users_raycast.global_transform.origin) #creates muzzle flash at barrel point

