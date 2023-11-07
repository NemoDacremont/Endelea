extends AnimatableBody2D

var speed = 1;
var oscillation_direction: Vector2;
var random = RandomNumberGenerator.new();
var t = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	sync_to_physics = false;
	random.randomize();
	var random_angle = random.randf()*2*PI;
	oscillation_direction = Vector2(cos(random_angle), sin(random_angle));
	var speed = random.randf()*10;
	t = random.randf()*2*PI;
	print(speed/10);
	print(random_angle/2/PI);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta;
	move_and_collide(speed*oscillation_direction*cos(t))
