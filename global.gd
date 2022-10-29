extends Node

var api_key
var game_id


func _ready():
	var f = File.new()
	f.open("res://.env", File.READ)
	api_key = str(f.get_line())
	game_id = str(f.get_line())
	f.close()

	SilentWolf.configure(
		{
			"api_key": str(api_key),
			"game_id": str(game_id),
			"game_version": "1.0.1",
			"log_level": 1,
		}
	)
