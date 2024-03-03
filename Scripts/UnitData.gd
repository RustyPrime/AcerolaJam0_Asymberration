
class_name UnitData

@export var name : String
@export var power : int
@export var path : String
@export var spawn_position : Vector3


func _init(unit_name, unit_power, unit_path, unit_position = Vector3.ZERO):
	self.name = unit_name
	self.power = unit_power
	self.path = unit_path
	self.spawn_position = unit_position

func ToJson():
	return JSON.stringify({"name": name, "power": power, "path": path, "spawn_position_x": spawn_position.x, "spawn_position_y": spawn_position.y, "spawn_position_z": spawn_position.z})

static func FromJSON(json):
	var jsonData = JSON.parse_string(json)
	var spawn_pos = Vector3(jsonData["spawn_position_x"],jsonData["spawn_position_y"], jsonData["spawn_position_z"])
	return UnitData.new(jsonData["name"], jsonData["power"], jsonData["path"], spawn_pos)
