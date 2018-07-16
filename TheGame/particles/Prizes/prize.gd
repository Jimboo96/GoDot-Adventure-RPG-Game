extends Area2D

signal get_prize

const prize_type = ["COIN", "HEART"]

var coin_res = preload("res://particles/Prizes/CoinsSprite.tscn")
var coin = coin_res.instance()
var heart_res = preload("res://particles/Prizes/heartSprite.tscn")
var heart = heart_res.instance()

var type
var type_r
var value

func _ready():
	randomize()
	set_prize_type()
	#print(type)
	hide()
	appear()	
	$hideTimer.connect("timeout", self, "disappear")
	$CollisionShape2D.disabled = true
	
func set_prize_type():
	var random_index = floor(rand_range(0, 2))
	#print(random_index)
	type = prize_type[random_index]
	print(type)
	match(type):
		"COIN":
			value = 5
			add_child(coin)
			type_r = coin
			pass
		"HEART":
			value = 20
			add_child(heart)
			type_r = heart
			pass
	pass

func appear():
	show()
	#print(type_r)
	type_r.play()
	$hideTimer.start()
	emit_signal("get_prize", type, value)
	$CollisionShape2D.disabled = false

func disappear():
	#print("from prize")
	queue_free()
