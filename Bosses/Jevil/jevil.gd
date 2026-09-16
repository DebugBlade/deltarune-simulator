extends Monster

const HURT_SOUNDS: Array[AudioStream] = [
	preload("uid://ddqyjm1rys2o"),
	preload("uid://0d3blfts7lbk"),
	preload("uid://b15measmd1hcd"),
]

func _ready() -> void:
	super()

func take_damage(damage: int, character: Character) -> void:
	super(damage, character)
	SoundManager.create_audio(HURT_SOUNDS.pick_random())
