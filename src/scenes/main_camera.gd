class_name MainCamera extends Camera3D

@export var move_speed:=5.0
@export var rotate_speed:=1.0
@export var farm:Farm

const RAYLEN:=10000
const EPSILON:=0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	var mouse_pos:=get_viewport().get_mouse_position()
	interact(mouse_pos)
	
func move(delta: float):
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


func get_point_coords(mouse_pos:Vector2)->Array[Vector3]:
	var from:=project_ray_origin(mouse_pos)
	var normal:=project_ray_normal(mouse_pos)
	var to:=from+normal*RAYLEN
	var rq:=PhysicsRayQueryParameters3D.new()
	rq.from=from
	rq.to=to
	var space:=get_world_3d().direct_space_state
	var ray_res:=space.intersect_ray(rq)
	if ray_res.is_empty():
		return []
	var ray_pos:Vector3=ray_res["position"]
	ray_pos+=normal*EPSILON
	ray_pos.y=0
	return [ray_pos]
	

func interact(mouse_pos:Vector2,is_clicked:bool=false):
	var test:=get_point_coords(mouse_pos)
	if test.is_empty():
		return
	var ray_pos:Vector3=test[0]
	var abs_pos:=farm.local_to_map(farm.to_local(ray_pos))
	assert(abs_pos.y==0)
	# var is_clicked:=Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	for coords in farm.get_used_cells():
		if coords.y!=0:
			farm.set_cell_item(coords,-1)
	farm.interact(ray_pos,is_clicked)
