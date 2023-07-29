extends Node
#20230413T1723; creation, of
#This is the main scene loading autoloader
#	any packed scenes or levels well be held here.
#I may use this as the main level loader as well but that may be within Omni.gd

#var loading_in_motion : bool = false #prevents mutliple loads
#var sceneloader = null


var _items = {
	smg_player_ = null,
	smg_mag = null,
}

#var game_scenes = {
#	city01 = "res://scenes/Maps/GameRoot City.tscn",
#	}

# Called when the node enters the scene tree for the first time.
func _ready():
	_items.smg_mag = load("res://scenes/smallItems/smg_mag_v01.tscn")
	


func create_item(to_replicate, future_parent, ammo_to_insert, loc):
	var replicate = null
	match to_replicate:
		0:
			replicate = _items.smg_mag.instantiate()
			replicate.pickup_type = 0
			replicate.ammo_can = ammo_to_insert
			future_parent.add_child(replicate)
			replicate.global_transform.origin = loc
			replicate.global_transform.origin += Vector3(-0.019, -0.049, 0.028) #mag placement
			replicate.rotation_degrees = Vector3(90, 90, 0) 
	
	return replicate #this allows the var to be referenced without too much hassle
