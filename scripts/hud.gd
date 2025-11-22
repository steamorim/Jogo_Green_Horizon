extends CanvasLayer

var vidas_icones = [] # Array para armazenar os ícones de vida

func _ready():
	# 1. Tenta encontrar o container.
	var container = $VidasContainer
	if not is_instance_valid(container):
		push_error("HUD Error: VidasContainer não encontrado!")
		return

	# 2. Popula o array com os ícones de vida (Vida1, Vida2, Vida3)
	for i in range(1, 4): 
		var vida_node = container.get_node_or_null("Vida" + str(i))
		if is_instance_valid(vida_node):
			vidas_icones.append(vida_node)
		else:
			push_error("HUD Error: Ícone Vida" + str(i) + " não encontrado!")


# Função pública para ser chamada pelo script do Personagem
func atualizar_vidas(vidas_atuais: int):
	# Verificação de segurança
	if vidas_icones.is_empty():
		return
		
	for i in range(vidas_icones.size()):
		var icone = vidas_icones[i]
		
		# i representa o índice (0, 1, 2). Se o índice for menor que as vidas atuais (3, 2, 1), ele é mostrado.
		if i < vidas_atuais:
			icone.show()
		else:
			icone.hide()
