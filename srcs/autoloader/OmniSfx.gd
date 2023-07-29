extends Node
#20230413T1750; creation of
#This autoloader is meant to load, hold, create and delete all sound effects in the game.
#Unforunately, I removed most of the sounds as they do not belong to me to give out. 
#	Which leads to you adding in sound effects; attribution is required and will be common practice.
#	- Some sites to get legal free music for most any project -
#		freesounds.org - Account req. Has a large amount of user submitted sounds, check for proper licenses.
#		zapsplat.com - Account req. and limited to 3-6 sound downloads every 10 minutes. 
#		incompetech.com - Personal repository of Kevin MacLeod's discography.



var global_bgm: AudioStreamPlayer = null #game overworld music player node

var gunshots = {
	smg =  load("res://assets/Audio/zapsplat/ShotSingleNear_weapon_gun_carl_gustav_m45_swedish_k_G_26.mp3"),
	click = load("res://assets/Audio/zapsplat/DryFire_zapsplat_m45_9mm.mp3"),
}

var foley = {
	wrong = load("res://assets/Audio/zapsplat_multimedia_game_sound_arcade_retro_8_bit_negative_fail_005_.ogg"),
	fart04 = load("res://assets/Audio/farts/classicfart2.mp3"),
	
}

var bootlegger_player = {
#	illegally_shared_music01_full_no_virus_exe = load("res://assets/Audio/copyright'd crap/Halo_ODST_ CD1_ 02 - The Rookie(FULL_EDIT2).mp3"),
	illegally_shared_music01_full_no_virus_exe = load("res://assets/Audio/zapsplat_multimedia_game_sound_arcade_retro_8_bit_negative_fail_005_.ogg"),
}

#var smg_content = {
#	smg_shot_1_ = load("res://assets/Audio/copyright'd crap/weapons/fire[smg_new01].wav"),
#	smg_shot_2_ = load("res://assets/Audio/copyright'd crap/weapons/fire[smg_new02].wav"),
#	smg_shot_3_ = load("res://assets/Audio/copyright'd crap/weapons/fire[smg_new03].wav"),
#	smg_shot_4_ = load("res://assets/Audio/copyright'd crap/weapons/fire[smg_new04].wav"),
#	smg_pickup1_ = load("res://assets/Audio/copyright'd crap/weapons/smg_ready[smg_ready1].wav"),
#	smg_pickup2_ = load("res://assets/Audio/copyright'd crap/weapons/smg_ready[smg_ready2].wav"),
#	}
	
var smg_content = {
	smg_shot_1_ = gunshots.smg,
	smg_shot_2_ = gunshots.smg,
	smg_shot_3_ = gunshots.smg,
	smg_shot_4_ = gunshots.smg,
	}
	
var smg_shots_ = [smg_content.smg_shot_1_,smg_content.smg_shot_2_,smg_content.smg_shot_3_,smg_content.smg_shot_4_]




#The 'type, node_caller, etc' are arguments. Think of this function as a shop; 
# What is asked v |					Is it delivery? v |
func createsfx(type: int, node_caller, set_precise_loc : bool, precise_loc): #precise_loc is a Vector3 but I think it looks ugly and that's the whole absolute reason
#					Who called ^ |					If delivery, where? ^ | 
	# ---- Working Example call lines --------
#	OmniSfx.createsfx(69, self, false, null) 
	#global fart effect
	
#	OmniSfx.createsfx(0, Omni.player_node.get_node("XRCamera3D"), true, Omni.player_node.global_transform.origin)
	#Pretty long line but flows the same. 
	
	var new_sfx = AudioStreamPlayer3D.new()
	match type:
		0:
			var selected_sfx = randi_range(0, smg_shots_.size() - 1)
			new_sfx.set_stream(smg_shots_[selected_sfx])
#			node_caller.get_parent().add_child(new_sfx)
		69: #childish placeholder, who did this?
			new_sfx.set_stream(foley.fart04)
		1:
			new_sfx.set_stream(gunshots.smg)
		2:
			new_sfx.set_stream(gunshots.click)
	
#	if new_sfx.get_parent() == null and !set_precise_loc:

	# --- Time to check set_precise_loc for audio --- 
	#get_parent(): sfx is stationary; if moving, it will rapidly become distant
	#add_child(): sfx follows, is allowed to finish
	if set_precise_loc:
		node_caller.get_parent().add_child(new_sfx)
		new_sfx.global_transform.origin = precise_loc
	else:
		node_caller.add_child(new_sfx)
		new_sfx.global_transform.origin = node_caller.global_transform.origin
		
	# -- sfx created, set, placed, time to send it out --
	new_sfx.play(0.0)
#	print("OmiSfx.gd: createsfx(0): created!")
	await new_sfx.finished
#	print("OmiSfx.gd: createsfx(0): deleting!!")
	new_sfx.queue_free()
			
		
