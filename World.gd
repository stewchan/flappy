extends Node2D

onready var hud = $HUD
onready var obstacle_spawner = $ObstacleSpawner
onready var ground = $Ground
onready var menu_layer = $MenuLayer

const SAVE_FILE_PATH = "user://savedata.save"

var score := 0 setget set_score
var highscore := 0


func _ready():
	obstacle_spawner.connect("obstacle_created", self, "on_obstacle_created")
	load_highscore()


# Start new game
func new_game():
	score = 0
	hud.update_score(score)
	obstacle_spawner.start()


# Increase score by 1
func player_score():
	self.score += 1


func set_score(new_score):
	score = new_score
	hud.update_score(score)


func on_obstacle_created(obstacle):
	obstacle.connect("score", self, "player_score")


func _on_DeathZone_body_entered(body: Node):
	if body is Player:
		if body.has_method("die"):
			body.die()


func _on_Player_died():
	game_over()


func game_over():
	obstacle_spawner.stop()
	ground.get_node("AnimationPlayer").stop()
	get_tree().call_group("obstacles", "set_physics_process", false)

	if score > highscore:
		highscore = score
		save_highscore()

	menu_layer.init_game_over_menu(score, highscore)


func _on_MenuLayer_start_game():
	new_game()


func save_highscore():
	# var save_data = File.new()
	# save_data.open(SAVE_FILE_PATH, File.WRITE)
	# save_data.store_var(highscore)
	# save_data.close()
	yield(SilentWolf.Scores.persist_score("Guest", highscore), "sw_score_posted")


func load_highscore():
	# var save_data = File.new()
	# if save_data.file_exists(SAVE_FILE_PATH):
	# 	save_data.open(SAVE_FILE_PATH, File.READ)
	# 	highscore = save_data.get_var() as int
	# 	save_data.close()
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
