extends AnimationPlayer
#20230414T1630; creation; it's meant to fire a large city wide effect after a time.
			#upon reconsideration, I may end up doing a AniTree, so items may change
			#	AniTree needs more thought to have multiple items play smoothly


@export var effect_time: int =  90
func _ready():
	
### critical debugging before putting headset on, left to show ####
##	get_parent().get_node("Pod/PodBox/MainV1/Ani").play("DoorFlapsClose")
##	var ttemp = get_tree().create_timer(1.2)
##	await ttemp.timeout
#	play("Drop")
#	var tttemp = get_tree().create_timer(30)
#	await tttemp.timeout
#	effect_timed_out()
##	print("confirmed await works like 3.5")
	
	OdstTempCore.showtime.connect(begin_show) #emits when OdstTempCore calls ani_get_down(3).

func begin_show():
	print("CAAni.gd: good check")
	var fate = randi() % 4
	match fate:
		0:
			play("CityAmbi_01")
		1:
			play("CityAmbi_01_2")
		2:
			play("CityAmbi_01_3")
		3:
			play("CityAmbi_02")

func effect_timed_out():
	var chance = randi() % effect_time #+ 20
	chance += .01 
#	chance = 10 #test only
	var timer = get_tree().create_timer(chance)
	await timer.timeout
	
	var fate = randi() % 4
	match fate:
		0:
			play("CityAmbi_01")
		1:
			play("CityAmbi_01_2")
		2:
			play("CityAmbi_01_3")
		3:
			play("CityAmbi_02")
