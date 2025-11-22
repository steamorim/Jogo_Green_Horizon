extends CanvasLayer # Ou o nó raiz do seu HUD

 
# 🚨 2. Referência ao nó que exibe as vidas (se houver)
@onready var vidas_container = $VidasContainer # Exemplo: TextureRect ou HBoxContainer

@onready var progress_lixo: TextureRect = $ProgressLixo 

# 🚨 Lista de Texturas (5 imagens)
const PROGRESS_TEXTURES: Array[Texture2D] = [
	preload("res://sprites/elementos/barra1.png"),  # Imagem 1 (0 lixo)
	preload("res://sprites/elementos/barra2.png"),  # Imagem 2 (1 lixo)
	preload("res://sprites/elementos/barra3.png"),  # Imagem 3 (2 lixos)
	preload("res://sprites/elementos/barra4.png"),  # Imagem 4 (3 lixos)
	preload("res://sprites/elementos/barra5.png"),  # Imagem 5 (4 lixos - Completo)
]

# ----------------------------------------
# NOVA FUNÇÃO: ATUALIZAÇÃO DO PROGRESSO DO LIXO
# ----------------------------------------
func atualizar_progresso_lixo(coletado: int, total: int) -> void:
	if not is_instance_valid(progress_lixo):
		push_error("TextureRect 'ProgressLixo' não encontrado no HUD.")
		return
		
	# O valor 'coletado' (0, 1, 2, 3, ou 4) é diretamente o ÍNDICE da nossa lista!
	# O índice de uma Array começa em 0.
	var texture_index: int = coletado
	
	# 1. Garante que o índice não saia dos limites (0 a 4)
	texture_index = clamp(texture_index, 0, PROGRESS_TEXTURES.size() - 1)
	
	# 2. Troca a textura do TextureRect
	progress_lixo.texture = PROGRESS_TEXTURES[texture_index]
	
	if coletado >= total:
		print("HUD: Coleta completa!")
