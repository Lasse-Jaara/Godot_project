extends AnimationPlayer
var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if animation_player.current_animation != "cat_walk":
	animation_player.play("cat_lazy_idle")
