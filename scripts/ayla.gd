extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
# 🚨 Referência para o nó HUD, que tem o script hud.gd
@onready var hud = get_parent().get_node("HUD") 

@onready var hud_progresso = get_parent().get_node("Hud_progresso") 

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var is_dead: bool = false
var origin_position: Vector2
var lives: int = 3 # ← Três vidas

# Variáveis de Coleta
var trash_collected: int = 0
var trash_total: int = 4 # Defina o total de lixo na fase.
# ... (restante das suas variáveis)

func _ready():
	# Salva a posição inicial do jogador
	origin_position = global_position
	
	# 🚨 Inicializa o HUD com o número correto de vidas
	if is_instance_valid(hud):
		hud.atualizar_vidas(lives)

# -----------------------------
# FUNÇÃO DE MORTE DO JOGADOR
# -----------------------------
func die():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	anim.play("dead")
	
	# Timer curto para animação de morte
	await get_tree().create_timer(0.4).timeout

	# Remove uma vida
	lives -= 1
	print("Vidas restantes: ", lives)
	
	# 🚨 ATUALIZA O HUD
	if is_instance_valid(hud):
		hud.atualizar_vidas(lives)

	if lives > 0:
		# Volta ao início
		global_position = origin_position
		velocity = Vector2.ZERO
		is_dead = false
		anim.play("idle")
	else:
		# Game Over
		print("Chamando GameOver...")
		game_over()

# -----------------------------
# GAME OVER (MANTIDO)
# -----------------------------
func game_over():
	print("GAME OVER!")

	# Trava o jogador
	is_dead = true
	velocity = Vector2.ZERO

	# Obtém o CanvasLayer (Mantenha o nome exato do seu nó CanvasLayer!)
	var ui_layer = get_tree().current_scene.get_node("UILayer")

	if not is_instance_valid(ui_layer):
		push_error("Nó UILayer não encontrado. Certifique-se de que ele existe na cena raiz.")
		return

	# Checa se já existe uma instância do Game Over
	var game_over_instance = ui_layer.get_node_or_null("GameOverUI")
	if not game_over_instance:
		# Carrega e instancia a cena de Game Over
		var game_over_scene = preload("res://entities/game_over.tscn")
		game_over_instance = game_over_scene.instantiate()
		game_over_instance.name = "GameOverUI"
		ui_layer.add_child(game_over_instance)

		# Configura para ocupar a tela inteira se for Control
		if game_over_instance is Control:
			game_over_instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Forma Godot 4 de preencher a tela
			game_over_instance.visible = false  # começa invisível

	# Ativa a tela de Game Over
	game_over_instance.visible = true

	# Toca a animação fade_in
	var anim_player = game_over_instance.get_node_or_null("AnimationPlayer")
	if anim_player:
		# 🚨 Use o nome EXATO da sua animação de Game Over
		anim_player.play("fade_in") 
# -----------------------------
# LOOP PRINCIPAL (MANTIDO)
# -----------------------------
func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_animation(direction)
	move_and_slide()
# -----------------------------
# SISTEMA DE ANIMAÇÃO (MANTIDO)
# -----------------------------
func _update_animation(direction: float) -> void:
	if direction > 0:
		anim.flip_h = true
		anim.play("lado")
	elif direction < 0:
		anim.flip_h = false
		anim.play("lado")
	else:
		anim.play("idle")
# -----------------------------
# COLISÃO COM INIMIGO (HITBOX) (MANTIDO)
# -----------------------------
func _on_hitbox_area_entered(area: Area2D) -> void:
	print("DEBUG: Hitbox tocou:", area.name)

	# LAVA DETECTADA
	if area.is_in_group("lava"):
		print("DEBUG: É lava → MORRE")
		die()
		return

	# INIMIGO DETECTADO
	var obj = area.get_parent()
	if obj.is_in_group("enemy"):
		if velocity.y > 0:
			print("DEBUG: Matou inimigo")
			obj.queue_free()
			velocity.y = JUMP_VELOCITY * 0.6
		else:
			print("DEBUG: Morreu pelo inimigo")
			die()
		return

	print("DEBUG: Não é lava nem inimigo")

# FUNÇÃO DE COLETA DE LIXO
# -----------------------------
func collect_trash():
	trash_collected += 1
	print("Lixo coletado: ", trash_collected, "/", trash_total)
	
	# 🚨 Notifica o HUD sobre o progresso
	if is_instance_valid(hud_progresso):
		hud_progresso.atualizar_progresso_lixo(trash_collected, trash_total)

	if trash_collected >= trash_total:
		# Lógica de vitória ou conclusão de fase
		print("Fase Concluída!")
		# Aqui você chamaria uma função 'level_complete()'
		
