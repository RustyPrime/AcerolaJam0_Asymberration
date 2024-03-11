
class_name EnemyData

@export var name : String
@export var power : int
@export var tier : int
@export var spawn_position : Vector3


func _init(enemy_name, enemy_power, enemy_tier, enemy_position = Vector3.ZERO):
	self.name = enemy_name
	self.power = enemy_power
	self.tier = enemy_tier
	self.spawn_position = enemy_position

func ToJson():
	return JSON.stringify({"name": name, "power": power, "tier": tier, "spawn_position_x": spawn_position.x, "spawn_position_y": spawn_position.y, "spawn_position_z": spawn_position.z})

static func FromJSON(json):
	var jsonData = JSON.parse_string(json)
	var spawn_pos = Vector3(jsonData["spawn_position_x"],jsonData["spawn_position_y"], jsonData["spawn_position_z"])
	return EnemyData.new(jsonData["name"], jsonData["power"], jsonData["tier"], spawn_pos)
