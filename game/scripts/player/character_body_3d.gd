extends CharacterBody3D


@export var sens_horizontal = 0.25 # horizontal "vasemmalle-oikealle" -hiiren herkyyden prosentti. 100 * 0.15 = 15 
@export var sens_vertical = 0.2 # pystysuora "ylös-alas"

@onready var animation_player = $visuals/model/Sketchfab_model/Root/AnimationPlayer
@onready var camera_mount = $visuals/camera_mount

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# --HIIRI--
func _ready(): # ottaa cursorin kiini näyttöön pelin laukastua.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event): # aktivoituu aina, kun jokin syöte tapahtuu pelissä.
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal)) # liikutetaan pelaajaa y akselilla hiiren vastaisen x akselin mukaan ja pienennetään liikettä hiiren herkyyden prosentin mukaan. Eli x*(-1)
		# deg_to_rad avulla muutetaan asteet radiaaneiksi. Kummatkin ovat kulman muuttujia.
		# -Mutta radiaani on ympyrä on jaettu 2 piin osaan eli radiaani on 1 = 57,3 astetta. Radiaania käytetään erityisesti fysiikasssa.
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical)) # Camera mountia liikutetaan x akselin hiiren y akselin vastaiseen likeen suntaa ja pienentä mällä herkyyden avulla.
		
	
	
	
	#if event.is_action_pressed("back_input"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE




# --PERUS LIIKUMINEN--
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_input") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left_input", "right_input", "forward_input", "backwards_input")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction: # if player is moving
		if !animation_player.current_animation == ("cat walk"):
			animation_player.play("cat walk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !animation_player.current_animation == ("cat lazy idle"):
			animation_player.play("cat lazy idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
