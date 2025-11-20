extends CharacterBody2D

const SPEED = 30.0         # Velocidade mais lenta
const MOVE_DISTANCE = 35.0 # Distância máxima que o inimigo percorre em cada direção

var direction := 1          # 1 = direita, -1 = esquerda
var start_position: Vector2 # Ponto inicial para calcular limites

func _ready() -> void:
	start_position = position
	
	# Inicia a animação do inimigo se houver AnimatedSprite2D
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("walk")  # "walk" é o nome da animação
		$AnimatedSprite2D.flip_h = (direction < 0)

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0

	# Movimento horizontal
	velocity.x = SPEED * direction

	# Aplica movimento
	move_and_slide()

	# Verifica limites e inverte direção se necessário
	if position.x > start_position.x + MOVE_DISTANCE:
		direction = -1
	elif position.x < start_position.x - MOVE_DISTANCE:
		direction = 1

	# Flip do sprite para a direção correta
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = (direction > 0)
