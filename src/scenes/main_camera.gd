@tool
class_name MainCamera extends Camera3D

@export var move_speed:=5.0
@export var rotate_speed:=1.0
@export var farm:Farm
@onready var test: MeshInstance3D = $"../test"

const RAYLEN:=10000
const EPSILON:=0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		move(delta)
	interact()
	
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

func interact():
	var rq:=PhysicsRayQueryParameters3D.new()
	var mouse_pos:=get_viewport().get_mouse_position()
	print(mouse_pos)
	rq.from=project_ray_origin(mouse_pos)
	var normal:=project_local_ray_normal(mouse_pos)
	rq.to=rq.from+normal*RAYLEN
	var space:=get_world_3d().direct_space_state
	var ray_res:=space.intersect_ray(rq)
	if ray_res.is_empty():
		return
	var ray_pos:Vector3=ray_res["position"]
	ray_pos+=normal*EPSILON
	test.position=ray_pos+Vector3.UP*1
	var abs_pos:=farm.local_to_map(farm.to_local(ray_pos))
	print(ray_pos,abs_pos)
	# farm.set_cell_item(abs_pos,0)
