extends Node

const JUMP_PARTICLE_EMITTING_DURATION: float = .1

@onready var jump: Node = get_parent()
@onready var player_node: CharacterBody2D = jump.get_parent().get_parent()

static var jumping_tween: Tween
@onready var animationNode: AnimatedSprite2D = get_tree().get_current_scene().find_child("Sprite")

@onready var jump_particles: GPUParticles2D = $JumpParticles
@onready var jump_particles_timer: Timer = $JumpParticlesTimer



func start():  # Just create impulsion
	player_node.velocity.y = PlayerConstants.JUMP_VELOCITY
	jumping_tween = get_tree().create_tween()
	jumping_tween.tween_property(animationNode, "scale", Vector2(.75, 1), PlayerConstants.PRE_JUMP_DURATION / 3)
	jumping_tween.tween_property(animationNode, "scale", Vector2(1, 1), PlayerConstants.PRE_JUMP_DURATION / 6)

	jump_particles.position = player_node.position + Vector2(0, 28)
	jump_particles.emitting = true
	jump_particles_timer.start(JUMP_PARTICLE_EMITTING_DURATION)

	jump.get_to_next_state()


func physics_process(_delta: float, _player: CharacterBody2D):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process():
	pass


func _on_jump_particles_timer_timeout():
	jump_particles.emitting = false

