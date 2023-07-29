extends XRToolsInteractableAreaButton
#20230413T1751; "creation" of

@export_enum("Initial Load","Special") var button_type : String = "Initial Load"

func _on_button_pressed(button):
	print("button_logic.gd: button pressed(): ", button_type)
	match button_type:
		"Initial Load": #initial load, comes from preloading area
#			OmiSceneLoader.load_scene(0)
			print("button_logic.gd: button pressed():")
			OdstTempCore.ani_get_down(1)




