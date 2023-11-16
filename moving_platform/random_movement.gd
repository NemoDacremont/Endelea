extends AnimatableBody2D

var speed_norm = 1;
var oscillation_direction: Vector2;
var random = RandomNumberGenerator.new();
var t:float = 0;
const TWO_PI = 2*PI;

# Called when the node enters the scene tree for the first time.
func _ready():
	sync_to_physics = false;
	random.randomize();
	var random_angle = random.randf()*2*PI;
	oscillation_direction = Vector2(cos(random_angle), sin(random_angle));
	speed_norm = random.randf()*10;
	t = random.randf()*TWO_PI;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t = fmod(t + delta,TWO_PI);
	move_and_collide(speed_norm*oscillation_direction*cos(t));
	
