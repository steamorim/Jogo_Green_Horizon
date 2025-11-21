# Script: portal.gd
extends Area2D

@export var proxima_fase: String = "res://scene/fase3_deserto.tscn"

@onready var transicao_anim: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect # O nó que fica preto
@onready var player_node: CharacterBody2D = null


func _ready():
	# Garante o estado inicial (Transparente e Visível)
	if is_instance_valid(color_rect):
		color_rect.visible = true
		color_rect.modulate = Color(1, 1, 1, 0.0)
		
	await get_tree().physics_frame
	monitoring = true


func _on_body_entered(body: Node2D) -> void:
	
	print("LOG COLISÃO: Sinal body_entered disparado por: ", body.name)
	
	if body is CharacterBody2D:
		player_node = body
		print("LOG DIAG: Personagem Ayla detectado.")
		
		# 🛑 LINHA REMOVIDA: player_node.process_mode = Node.PROCESS_MODE_DISABLED
		# O movimento do personagem não será travado.
		print("LOG DIAG: Movimento do personagem NÃO está travado (CONTINUA SE MOVENDO).")
			
		if is_instance_valid(color_rect):
			# Reforça a visibilidade do elemento que será animado
			color_rect.visible = true
			print("LOG DIAG: ColorRect visível definido como TRUE.")
		else:
			push_error("LOG ERRO CRÍTICO: ColorRect é inválido! A transição não pode aparecer.")
			
		
		# Início da Lógica da Animação
		if transicao_anim:
			print("LOG DIAG: AnimationPlayer encontrado.")
			
			if transicao_anim.has_animation("fade_out"):
				print("LOG DIAG: Animação 'fade_out' encontrada no Player.")
				
				# ATIVAÇÃO EXPLÍCITA DO PLAYER
				transicao_anim.active = true
				print("LOG DIAG: AnimationPlayer ativo = TRUE.")
				
				# Inicia a animação de fade out.
				transicao_anim.play("fade_out")
				print("LOG DIAG: Animação 'fade_out' INICIADA. Aguardando a conclusão...")
				
				# O jogo trava AQUI pelo tempo da animação (1.5s)
				await transicao_anim.animation_finished
				print("LOG SUCESSO: Animação concluída. A tela ficou preta.")
			else:
				push_error("LOG ERRO: Animação 'fade_out' não existe. Verifique o nome da animação.")
				
		else:
			push_error("LOG ERRO CRÍTICO: AnimationPlayer é inválido! A transição foi pulada.")
		
		# Mudança de cena
		print("LOG MUDANÇA: Tentando mudar para a fase: ", proxima_fase)
		var erro = get_tree().change_scene_to_file(proxima_fase)
		
		if erro != OK:
			push_error("LOG ERRO CRÍTICO: Falha ao carregar fase: ", proxima_fase, " Erro: ", erro)
		else:
			print("LOG MUDANÇA: Transição de cena bem-sucedida!")
	else:
		print("LOG AVISO: Colisão ignorada. Não é a personagem Ayla.")
