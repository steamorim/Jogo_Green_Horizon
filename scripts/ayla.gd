extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_parent().get_node("HUD")
@onready var hud_progresso = get_parent().get_node("Hud_progresso")

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Caminho da cena de Game Over (VERIFIQUE NOVAMENTE!)
const GAME_OVER_SCENE_PATH = "res://entities/game_over_screen.tscn"

var is_dead: bool = false
var origin_position: Vector2
var lives: int = 3

var trash_collected: int = 0
var trash_total: int = 4


func _ready():
    origin_position = global_position
    
    if is_instance_valid(hud):
        hud.atualizar_vidas(lives)
    
    if is_instance_valid(hud_progresso):
        hud_progresso.atualizar_progresso_lixo(trash_collected, trash_total)


# -----------------------------
# FUNÇÃO DE MORTE DO JOGADOR
# -----------------------------
func die():
    if is_dead:
        return

    is_dead = true
    velocity = Vector2.ZERO
    anim.play("dead")
    
    # O delay inicial de 0.4s foi removido daqui e ajustado nos blocos IF/ELSE
    
    lives -= 1
    
    if is_instance_valid(hud):
        hud.atualizar_vidas(lives)

    if lives > 0:
        # --- RESPAWN: Delay de 0.6s antes de reviver ---
        await get_tree().create_timer(0.6).timeout 
        
        # Respawn
        global_position = origin_position
        velocity = Vector2.ZERO
        is_dead = false
        anim.play("idle")
    else:
        # --- GAME OVER: Delay de 1.15s antes de carregar a UI ---
        await get_tree().create_timer(1.15).timeout 
        
        # Carrega a UI (A pausa será feita dentro da função load_game_over_screen)
        load_game_over_screen()


# -----------------------------
# FUNÇÃO DE CARREGAR GAME OVER
# -----------------------------
func load_game_over_screen():
    
    # --- AJUSTE CRÍTICO: PAUSA O JOGO IMEDIATAMENTE ---
    get_tree().paused = true
    
    var game_over_scene = load(GAME_OVER_SCENE_PATH)
    
    if game_over_scene == null:
        print("ERRO: O caminho da cena de Game Over está incorreto: ", GAME_OVER_SCENE_PATH)
        return
        
    var game_over_screen = game_over_scene.instantiate()
    
    get_tree().root.add_child(game_over_screen)
    


# -----------------------------
# LOOP PRINCIPAL
# -----------------------------
func _physics_process(delta: float) -> void:
    if is_dead:
        velocity = Vector2.ZERO
    else:
        if not is_on_floor():
            velocity += get_gravity() * delta

        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = JUMP_VELOCITY

        var direction := Input.get_axis("left", "right")
        if direction != 0:
            velocity.x = direction * SPEED
        else:
            velocity.x = move_toward(velocity.x, 0, SPEED)

        _update_animation(direction)
        
    move_and_slide()


# -----------------------------
# SISTEMA DE ANIMAÇÃO E COLISÃO
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


func _on_hitbox_area_entered(area: Area2D) -> void:
    if area.is_in_group("lava"):
        die()
        return

    var obj = area.get_parent()
    if obj.is_in_group("enemy"):
        if velocity.y > 0:
            obj.queue_free()
            velocity.y = JUMP_VELOCITY * 0.6
        else:
            die()
        return
    
    if area.is_in_group("trash_collectible"):
        collect_trash()
        area.queue_free()
        return


func collect_trash():
    trash_collected += 1
    
    if is_instance_valid(hud_progresso):
        hud_progresso.atualizar_progresso_lixo(trash_collected, trash_total)

    if trash_collected >= trash_total:
        pass

func _on_lava_area_body_entered(_body: Node2D) -> void:
    pass
