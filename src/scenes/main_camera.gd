class_name MainCamera extends Camera3D

@export var move_speed:=5.0
@export var rotate_speed:=1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var base_direction:=Input.get_vector("move_left","move_right","move_forward","move_back")
	base_direction=base_direction.normalized()
	var forward:=global_transform.basis.z*Vector3(1,0,1)
	var right:=global_transform.basis.x*Vector3(1,0,1)
	var movement:=Vector3.ZERO
	movement+=right*base_direction.x
	movement+=forward*base_direction.y
	movement*=delta*move_speed
	position+=movement
	
	var turn_direction:=Input.get_axis("spin_left","spin_right")
	rotate_y(turn_direction*delta*rotate_speed)
