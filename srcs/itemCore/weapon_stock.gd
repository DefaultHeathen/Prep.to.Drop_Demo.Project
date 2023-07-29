extends XRToolsInteractableHandle

@export_node_path("RigidBody3D") var weapon_root #the weapons rigidBody pickable root

func pick_up(by, with_controller) -> void:
	if get_node(weapon_root).is_picked_up(): #just a simple check to avoid grabbing the stock
		super(by, with_controller)
