# Script: hud.gd
extends CanvasLayer

var vidas_icones = [] # Inicializa como array vazio (sempre seguro)

func _ready():
	# 1. Tenta encontrar o container. Se o nome estiver errado, dará erro aqui.
	var container = $VidasContainer
	if not is_instance_valid(container):
		push_error("HUD Error: VidasContainer não encontrado!")
		return # Para a execução se o nó não estiver lá

	# 2. Popula o array de forma segura
	for i in range(1, 4): # Vai de 1 a 3 (Vida1, Vida2, Vida3)
		var vida_node = container.get_node_or_null("Vida" + str(i))
		if is_instance_valid(vida_node):
			vidas_icones.append(vida_node)
		else:
			push_error("HUD Error: Ícone Vida" + str(i) + " não encontrado!")

	# Se você for chamar atualizar_vidas no ready da Ayla, remova o código abaixo.
	# Mas se quiser inicializar o estado visual no HUD, mantenha.
	# if vidas_icones.size() > 0:
	#     atualizar_vidas(3) 

# Função pública para ser chamada pelo script da Ayla
func atualizar_vidas(vidas_atuais: int):
	# 🚨 Verificação de segurança (Impede o erro 'Nil')
	if vidas_icones.is_empty():
		print("HUD Warning: Vidas ícones vazios. Ignorando atualização.")
		return 
		
	for i in range(vidas_icones.size()):
		var icone = vidas_icones[i]
		
		if i < vidas_atuais:
			icone.show() 
		else:
			icone.hide()
