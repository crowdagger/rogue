extends CanvasLayer

@onready var fps = $GridContainer/FPS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fps.text = str(Engine.get_frames_per_second())
	$GridContainer/LifeLabel.text = str(Global.hp)
	$GridContainer/CoinLabel.text = str(Global.coins)

