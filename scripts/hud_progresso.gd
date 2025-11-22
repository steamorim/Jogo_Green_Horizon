extends CanvasLayer 

@onready var vidas_container = $VidasContainer 
@onready var progress_lixo: TextureRect = $ProgressLixo

const PROGRESS_TEXTURES: Array[Texture2D] = [
	preload("res://sprites/elementos/barra1.png"),  
	preload("res://sprites/elementos/barra2.png"),  
	preload("res://sprites/elementos/barra3.png"),  
	preload("res://sprites/elementos/barra4.png"),  
	preload("res://sprites/elementos/barra5.png")   
]

func _ready():
	atualizar_progresso_lixo(0, 4) 


# ----------------------------------------
# NOVA FUNÇÃO: ATUALIZAÇÃO DO PROGRESSO DO LIXO
# ----------------------------------------
func atualizar_progresso_lixo(coletado: int, total: int) -> void:
	if not is_instance_valid(progress_lixo):
		push_error("TextureRect 'ProgressLixo' não encontrado no HUD.")
		return
		
	var texture_index: int = coletado
	
	texture_index = clamp(texture_index, 0, PROGRESS_TEXTURES.size() - 1)
	
	progress_lixo.texture = PROGRESS_TEXTURES[texture_index]
	
	if coletado >= total:
		print("HUD: Coleta completa!")


# ----------------------------------------
# FUNÇÃO DE ATUALIZAÇÃO DE VIDAS (Placeholder)
# ----------------------------------------
func atualizar_vidas(vidas_atuais: int):
	print("HUD: Vidas atualizadas para ", vidas_atuais)
	pass
