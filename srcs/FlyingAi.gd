extends CharacterBody3D
#Non working Phantom code

var vel = Vector3()
var order_point = null
@export var speed = 5.0
@onready var navi_ag : NavigationAgent3D = $NavigationAgent3D
var speed_gear = {
	fast = 15.0,
	slow = 5.0,
	stopped = 0.0001,
}

#func _ready():
#	await get_tree().create_timer(1.0).timeout
#	gen_orders()

func gen_orders():
	var skypoints = get_tree().get_nodes_in_group("SkyPoint")
	randomize()
	var chosen_ = randi_range(0, (skypoints.size() - 1))
	move_to(skypoints[chosen_].global_transform.origin, speed_gear.slow)

func _physics_process(delta):
#	if ani_state > bag.ani_mid_point:
	var target = navi_ag.get_next_path_position()
	var pos = get_global_transform().origin #global_position
	var n = $RayCast3D.get_collision_normal()
	if n.length_squared() < 0.001:
		n = Vector3(0, 1, 0) #if this occurs, the node loops in place(?)
#		print("!!")
	vel = (target - pos).slide(n).normalized() * speed
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), delta *10)
	
	navi_ag.set_velocity(vel)
	
#	move_and_slide()

#		if ani_state != ANI_STATE.IDLE_STAND or ani_state != ANI_STATE.IDLE_CROUCH:


func move_to(target_pos, pace):
	speed = pace
	navi_ag.set_avoidance_enabled(true)
	order_point = target_pos
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	navi_ag.set_target_position(closest_pos)
	print("FlyingAi_.gd: move_to: target_pos: ", target_pos, "actual pos: ", closest_pos,"| Distance to:", global_transform.origin.distance_to(closest_pos))





func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)
	move_and_slide()
