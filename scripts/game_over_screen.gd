extends Control

const MAIN_SCENE_PATH = "res://scene/game.tscn"
var final_score = 0

# Assumindo que o AnimationPlayer se chama "AnimationPlayer"
# @onready var anim: AnimationPlayer = $AnimationPlayer 

func _ready():
	# --- AJUSTE CRÍTICO ---
	# get_tree().paused = false FOI REMOVIDO DAQUI. 
	# O jogo permanecerá PAUSADO até que o botão Restart seja pressionado.
	
	# Inicia a animação (se o nó existir e o Pause Mode for Process)
	# if is_instance_valid(anim):
	#     anim.play("fade_in")
	
	# Conexões dos botões
	$VBoxContainer/Restart.connect("pressed", _on_Restart_pressed)
	$VBoxContainer/Quit.connect("pressed", _on_Quit_pressed)


## --- Funções de Botão --- ##

func _on_Restart_pressed():
	# 1. Despausa o jogo ANTES de trocar de cena (CRÍTICO)
	get_tree().paused = false
	
	# 2. Remove a tela de Game Over
	queue_free()
	
	# 3. Recarrega a cena principal
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

func _on_Quit_pressed():
	get_tree().quit()
