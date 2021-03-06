extends CanvasLayer

onready var buy_coins = get_node( "BuyCoins" )
onready var coins_number = get_node( "CoinsNumber" )
onready var death_screen = get_node( "DeathScreen" )
onready var pause_screen = get_node( "PauseScreen" )
onready var power_up_wrapper = get_node( "PowerUpWrapper" )

var _window_size

var power_ups_icons = {
	Player.power_ups.laser: preload("res://Assets/Icons/FireWithMyLaza.png"),
	Player.power_ups.life: preload("res://Assets/Icons/extraLife.png"),
	Player.power_ups.gun: preload("res://Assets/Icons/overpowerdGun.png"),
	Player.power_ups.frenzy: preload("res://Assets/Icons/onePunchFrenzy.png"),
	Player.none: ImageTexture.new()
}

func _ready():
	Player.ui = self
	
	_window_size = OS.get_window_size()
	
	Player.connect( "coins_updated", self, "update_coins" )
	Player.connect( "power_up_gained", self, "update_power_up" )
	update_coins( Player.coins )
	
	set_process_unhandled_input( true )
	
	# DEATH SCREEN
	for screen in [death_screen, pause_screen]:
		screen.hide()
		screen.set_size( _window_size )
		screen.get_node( "Quit" ).set_pos( Vector2( _window_size.x/3, _window_size.y/10 * 9 ) )
		screen.get_node( "Retry" ).set_pos( Vector2( _window_size.x/3 * 2, _window_size.y/10 * 9 ) )
	
	# BUY COINS
	buy_coins.set_pos( Vector2( _window_size.x / 2 - buy_coins.get_node( "Frame" ).get_size().x / 2, _window_size.y / 2 ) )

func _unhandled_input(event):
	if event.is_action_pressed( "pause" ):
		if get_tree().is_paused():
			pause_screen.hide()
			get_tree().set_pause( false )
		else:
			pause_screen.show()
			get_tree().set_pause( true )


##########################
# COINS
##########################

func update_coins( current_amount ):
	coins_number.set_text( str( "Coins: ", current_amount ) )


func show_buy_coins():
	buy_coins.show()


func hide_buy_coins():
	buy_coins.hide()


func _on_CloseBuyCoins_pressed():
	hide_buy_coins()


func _on_RichTextLabel_meta_clicked( meta ):
	OS.shell_open( meta )

###########################
# DEATH
###########################

func show_death_screen():
	get_tree().set_pause( true )
	death_screen.show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Retry_pressed():
	if Player.update_coins( -Player.LIFE_COST ):
		get_tree().set_pause( false )
		get_tree().reload_current_scene()


###########################
# POWER UPS
###########################

func update_power_up( power_up ):
	power_up_wrapper.set_texture( power_ups_icons[power_up] )


func _on_DeathScreen_visibility_changed():
	if death_screen.is_visible(): death_screen.get_node( "Retry" ).grab_focus()


func _on_PauseScreen_visibility_changed():
	if pause_screen.is_visible(): pause_screen.get_node( "Retry" ).grab_focus()
