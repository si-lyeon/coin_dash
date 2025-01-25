extends Area2D


signal pickup
signal hurt


@export var speed = 350


var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)


func _process(delta: float) -> void:
	# 플레이어 입력 나타내는 벡터 구한 후 화면 안에서 이동하고 경계선을 넘지 못하게 자름.
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# 어느 애니메이션을 플레이할지 고른다.
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start():
	# 새 게임 시작 시 플레이어 재설정
	set_process(true)
	position = screensize/2
	$AnimatedSprite2D.animation = "idle"

func die():
	# 플레이어 사망 시 이 함수 호출
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area: Area2D) -> void:
	# 오브젝트에 닿을 경우, 무엇을 할지 결정
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit()
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
