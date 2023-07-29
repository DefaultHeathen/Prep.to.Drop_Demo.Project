extends Node
#20230414T1649; creation of

#Autoload focusing on the player and key aspects of the game.


var player_node = null
var current_scene = null
var groot_ani : AnimationPlayer = null
var w_e : WorldEnvironment = null



func _ready():
#	var xr_interface : XRInterface = XRServer.find_interface("OpenXR")
#	if xr_interface and xr_interface.is_initialized():
#		var vp: Viewport = get_viewport()
#		vp.use_xr = true

	player_node = get_parent().get_node("UniRoot/Player")
	current_scene = get_parent().get_node("UniRoot/GameRoot City")
	groot_ani = current_scene.get_node("GameRootAni")
	w_e = get_parent().get_node("UniRoot/WorldEnvironment")
	OmniSfx.global_bgm = current_scene.get_node("BGM")

		


func player_lock(): #no bool? wild
	#prevents player input from moving and going into places they shouldn't.
	#can still walk around so use a "black bag" effect
	match player_node.get_node("PlayerBody").axis_lock_linear_x:
		true: #player is 'locked', now to 'unlock' them
			player_node.get_node("PlayerBody").axis_lock_linear_x = false
			player_node.get_node("PlayerBody").axis_lock_linear_y = false
			player_node.get_node("PlayerBody").axis_lock_linear_z = false
			player_node.get_node("PlayerBody").axis_lock_angular_x = false
			player_node.get_node("PlayerBody").axis_lock_angular_y = false
			player_node.get_node("PlayerBody").axis_lock_angular_z = false
			
		false: #player is 'unlocked', now to 'lock' them
			player_node.get_node("PlayerBody").axis_lock_linear_x  = true
			player_node.get_node("PlayerBody").axis_lock_linear_y  = true
			player_node.get_node("PlayerBody").axis_lock_linear_z  = true
			player_node.get_node("PlayerBody").axis_lock_angular_x  = true
			player_node.get_node("PlayerBody").axis_lock_angular_y  = true
			player_node.get_node("PlayerBody").axis_lock_angular_z  = true
	pass
	

func game_paused():
	#20230709T1313; ripped from another project
	match get_tree().is_paused():
		true:
			get_tree().paused = false
		false:
#			distant_boom(null,misc.player_heart.global_transform.origin,paused_sfx) #20221111T2326; alright, so this calls the heart.gd which idk if it's a good idea to extempt it from pausing, maybe it's a good idea, to prevent the player from fucking the loading crap
			OmniSfx.createsfx(69, self, false, null)
			get_tree().paused = true


func _unhandled_key_input(event):
	#debugging BEFORE putting headset on; the 'P' key on physical keyboards, pauses the game
	if event.is_action_released("pause"):
		game_paused()


func player_damage(inputted_amount):
	print("Omni.gd: player_damage(): ",inputted_amount,"; To be included!")
#	if block input > dict.mega_ouch and input < dict.owwies_i_give_up:
#		omniSfx.create_sfx(gasping, grunting, crying, dying)
#		callofbloodsplatter.red_hue_pre_max
