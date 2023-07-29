extends Node
#20230414T1655; to be concise, this will hold everything to get keep the game running.
#it's going to be messy
#20230415T1653; working around this central temp node is actually pretty helpful!

#This Autoload focuses on the "cinematic" experience around the player. Consider it as a playbill 
#	of this scene. Also keeps everything else clean, as I can swap the it out for a 
#	proper src/.gd/script later.


var show_flag : int = 0

signal showtime


#func _ready():
##leaving this here to show the testing steps taken to test out the 
##	"cinematic" part working BEFORE putting on the headset. 
#
##	var temp = get_tree().create_timer(1.9)
##	await temp.timeout
###	print("yo")
#	ani_get_down(1)
#	ani_get_down(2)
#	ani_get_down(3)
##	var temp2 = get_tree().create_timer(9)
##	await temp2.timeout
##	get_parent().get_node("UniRoot/Weapon_2").emit_signal("picked_up", 2) #see note below; good check.
##	print("!")
##	var temp3 = get_tree().create_timer(9)
##	await temp3.timeout
##	print(get_parent().get_node("UniRoot/Weapon_2").get_signal_connection_list("picked_up")) #20230710T1702; alright I "get" it. Format from now

func ani_get_down(type_beat):
	#The linear cinematic portion of the game.
	#Uses heavily the animations 
	print("ODST_RC_BB.gd: agd(type): firing, type: ", type_beat)
	match type_beat:
		0: #set table
			Omni.groot_ani.play("RESET")
			await Omni.groot_ani.animation_finished
			Omni.groot_ani.play("Smoke_check")
			
		
		1: #present arms (button pressed)
			if show_flag < 1:
				show_flag = 1
				print("ODST_RC_BB.gd: agd(1): showing gun")
				get_parent().get_node("UniRoot/Weapon_").show()
				get_parent().get_node("UniRoot/Weapon_").proxy.connect(Callable(self, "ani_get_down"), 4)
		
		2:	#prepare to-
			if show_flag == 1:
				show_flag = 2
				
				print("ODST_RC_BB.gd: agd(2): PRE-GAME LOBBY!!")
				var atm_gun = get_parent().get_node("UniRoot/Weapon_")
				var hand = atm_gun.by_controller.get_node("FunctionPickup")
				hand.drop_object()
				
				#forceably affix player into position/rotation.
				Omni.current_scene.get_node("Pod/PodBox/MainV1/DropPodExportable/Door/CollisionShape3D").disabled = false
				Omni.player_lock() #locks player movement controls
				Omni.player_node.get_parent().remove_child(Omni.player_node)
				Omni.current_scene.get_node("Pod").add_child(Omni.player_node) 
				Omni.player_node.global_position = Omni.current_scene.get_node("Pod/PlayerSeat").global_transform.origin
				XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true) #This requires player feedback, really need a tester playerbase
				Omni.player_node.rotation_degrees.y += -90 #this seems dumb and may break a cardinal rule
				
				hand._pick_up_object(atm_gun) #fix gun
				
				Omni.current_scene.get_node("Pod").show()
				Omni.current_scene.get_node("Pod/PodBox/MainV1/Ani").play("DoorFlapsClose")
				OmniSfx.createsfx(69, Omni.current_scene.get_node("Pod"), false, null) #play dohicky
				var ttimer = get_tree().create_timer(2.8)
				await ttimer.timeout
				ani_get_down(3)
				
			
		3: #Drop!
			if show_flag == 2:
				show_flag = 3
				Omni.w_e.environment = OmniEffects.world_e.nemombasa
				Omni.current_scene.get_parent().get_node("Preloading").hide()
				OmniSfx.global_bgm.set_stream(OmniSfx.bootlegger_player.illegally_shared_music01_full_no_virus_exe)
				OmniSfx.global_bgm.play(0.0)
				Omni.groot_ani.play("Drop")
				await get_tree().create_timer(10).timeout
				emit_signal("showtime")
			
			


#func _on_xr_tools_interactable_area_button_button_pressed(button):
#	#debug stuff, uncomment to see controller input (They added in touch!!)
#	print("ODST_RCBB.gd: button pressed(): !")
#	print(button)
