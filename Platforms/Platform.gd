extends KinematicBody2D

onready var dir_t = get_node( "DirectionTimer" )

export( int ) var SPEED = 70
export( bool ) var IS_MOVING_PLATFORM = false
export( int ) var DIR_CHANGE_TIMER = 1
export( int, "Left-Right", "Right-Left", "Top-Down", "Bottom-Up" ) var DIR_PLATFORM = 0

var _velocity = Vector2( 0, 0 ) setget set_velocity, get_velocity
var movement_phase = 0

func _ready():
	add_to_group( "platform" )
	
	if IS_MOVING_PLATFORM:
		add_to_group( "moving_platform" )
		
		set_fixed_process( true )
		
		dir_t.set_wait_time( DIR_CHANGE_TIMER )
		dir_t.connect( "timeout", self, "direction_change")
		dir_t.start()
		
		# Start the platform
		direction_change()

func _fixed_process( delta ):
	move( _velocity * delta )

##################
# DIRECTION
##################

func direction_change():
	if not IS_MOVING_PLATFORM:
		return
		
	if DIR_PLATFORM == 0:
		if movement_phase == 0:
			_velocity = Vector2( SPEED, 0 )
		else:
			_velocity = Vector2( -SPEED, 0 )
	elif DIR_PLATFORM == 1:
		if movement_phase == 0:
			_velocity = Vector2( -SPEED, 0 )
		else:
			_velocity = Vector2( SPEED, 0 )
	elif DIR_PLATFORM == 2:
		if movement_phase == 0:
			_velocity = Vector2( 0, SPEED )
		else:
			_velocity = Vector2( 0, -SPEED )
	elif DIR_PLATFORM == 3:
		if movement_phase == 0:
			_velocity = Vector2( 0, -SPEED )
		else:
			_velocity = Vector2( 0, SPEED )


##################
# SETGET
##################

func set_velocity( vector ):
	_velocity = vector

func get_velocity():
	return _velocity