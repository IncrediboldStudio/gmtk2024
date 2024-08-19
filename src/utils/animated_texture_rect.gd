extends TextureRect

class_name AnimatedTextureRect

@export var sprite_frames : SpriteFrames : set = _set_sprite_frames
@export var animation = "default" : set = _set_animation

var frame : int : set = _set_frame
var frame_count : int
var frame_time : float
var time_since_last_frame : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite_frames:
		_set_sprite_frames(sprite_frames)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if sprite_frames:
		time_since_last_frame = time_since_last_frame + delta
		var nb_frames_till_last_update = time_since_last_frame / frame_time
		if nb_frames_till_last_update > 1:
			frame = frame + int(nb_frames_till_last_update)
			time_since_last_frame = time_since_last_frame - (nb_frames_till_last_update * frame_time)

func _set_sprite_frames(value : SpriteFrames):
	sprite_frames = value
	if value == null:
		return
	frame_count = sprite_frames.get_frame_count(animation)
	frame_time = 1 / sprite_frames.get_animation_speed(animation)
	time_since_last_frame = 0
	frame = 0

func _set_frame(value : int):
	frame = value
	if frame >= frame_count:
		frame = frame - frame_count
	texture = sprite_frames.get_frame_texture(animation, frame)

func _set_animation(value : String):
	animation = value
	#Reset Frame since we changed animation
	sprite_frames = sprite_frames
