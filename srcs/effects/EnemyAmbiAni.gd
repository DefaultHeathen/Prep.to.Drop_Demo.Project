extends AnimationPlayer
#20230414T1630; creation; it's meant to fire a large city wide effect after a time.
#20230709T2053; resumed yesterday, splitted this from the orignal, prep for public "poc" release

@export var effect_time: int =  90

func _ready():
	OdstTempCore.showtime.connect(begin_show)

func begin_show():
	print("EAAni.gd: good check")
	var fate = randi() % 3
	match fate:
		0:
			play("EnemyAmbi_01")
		1:
			play("EnemyAmbi_02")
		2:
			play("EnemyAmbi_11")


func effect_timed_out():
	randomize()
	var chance = randi() % effect_time #+ 20
	chance += .01 
#	chance = 10 #test only
	var timer = get_tree().create_timer(chance)
	await timer.timeout
	
	var fate = randi() % 3
	match fate:
		0:
			play("EnemyAmbi_01")
		1:
			play("EnemyAmbi_02")
		2:
			play("EnemyAmbi_11")
