extends CanvasLayer

func set_focus():
	$MarginContainer/VBoxContainer/Resume.grab_focus()

func _ready():
	set_focus()

func _on_resume_pressed():
	Global.pause_menu()


func _on_quit_pressed():
	get_tree().quit()
