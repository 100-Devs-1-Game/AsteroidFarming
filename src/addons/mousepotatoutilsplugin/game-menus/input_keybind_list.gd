@tool
class_name InputKeybindList extends MpupUiObjectList

var is_remapping:=false
var action_to_remap=null
var remapping_button:MultipleInputKeybind=null

var events_by_name:Dictionary[String,InputEvent]

@export var skip:Dictionary[String,int]={"^ui*":1}
@export var include:Dictionary[String,int]={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_action_list()

func get_valid_actions()->Array[StringName]:
	var actions:=InputMap.get_actions()
	var skipped:Dictionary[String,int]
	for raw in skip:
		var power:=skip[raw]
		var re:=RegEx.new()
		var temp:=re.compile(raw)
		for i in range(len(actions)):
			var act:=actions[i]
			if act in skipped:
				continue
			var searched:=re.search(act)
			if searched:
				skipped[act]=power
			else:
				pass
	for raw in include:
		var power:=include[raw]
		var re:=RegEx.new()
		var temp:=re.compile(raw)
		for act in skipped.keys():
			if skipped[act]<=power:
				skipped.erase(act)
	var res:Array[StringName]=[]
	for name in actions:
		if name not in skipped:
			res.append(name)
	return res

func _cal_for_button(action:StringName)->Dictionary:
	var events:=InputMap.action_get_events(action)
	var event_names:Dictionary[String,String]={}
	for event in events:
		var name:String=event.as_text()
		event_names[name]=name
		events_by_name[name]=event
	var ev_text:String="" if events.is_empty() else events[0].as_text()
	ev_text=ev_text.replace(" (Physical)","")
	return {"action":action,"buttons":event_names}
	
func _create_action_list():
	InputMap.load_from_project_settings()
	var data:Dictionary[String,Dictionary]={}
	var actions=get_valid_actions()
	for action in actions:
		data[action]=_cal_for_button(action)
	self.setup(data)


func setup_element(object:MpupUiObjectListItem):
	var true_object:MultipleInputKeybind=object
	true_object.sig_remove_button.connect(
		self.remove_button.bind(true_object.name_t.text)
	)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_button(name:String,action_to_remap:String):
	var event:InputEvent=self.events_by_name.get(name)
	if event==null:
		return
	InputMap.action_erase_event(action_to_remap,event)
	return

func on_button_press(key:String, item):
	if not is_instance_of(item,MultipleInputKeybind):
		return
	var true_item:MultipleInputKeybind=item
	if self.is_remapping:
		return
	is_remapping=true
	action_to_remap=key
	remapping_button=item
	true_item.toggle_adding(true)
	return

func _input(event: InputEvent) -> void:
	if not self.is_remapping:
		return
	var is_valid:=false
	if event is InputEventKey:
		is_valid=true
	if (not is_valid) and event is InputEventMouseButton:
		var iemb:InputEventMouseButton
		iemb=event
		if not iemb.is_pressed():
			return
		iemb.double_click=false
		is_valid=true
	if not is_valid:
		return
	InputMap.action_add_event(action_to_remap,event)
	var ev_text:=get_event_as_text(event)
	self.remapping_button.add_button(ev_text,ev_text)
	self.remapping_button.toggle_adding(false)
	
	self.remapping_button=null
	self.is_remapping=false
	self.action_to_remap=null
	accept_event()

static func get_event_as_text(event:InputEvent)->String:
		var ev_text:String=event.as_text()
		# ev_text=ev_text.replace(" (Physical)","")
		return ev_text
	
