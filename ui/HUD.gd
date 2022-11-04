extends CanvasLayer

onready var score_label = $ScoreLabel


# Update the score
func update_score(score):
	score_label.text = str(score)
