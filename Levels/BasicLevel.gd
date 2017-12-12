extends TileMap

onready var platforms = get_node( "Platforms" )
onready var items = get_node( "Items" )
onready var collectibles = get_node( "Collectibles" )
onready var endpoints = get_node( "PatrolEndpoints" )
onready var enemies = get_node( "Enemies" )


func _ready():
	Player.current_level = self


###############
# ITEMS
###############

func add_item( item, pos ):
	items.add_child( item )
	item.set_pos( pos )


func remove_item( item ):
	items.remove_child( item )
	item.queue_free()


###############
# COLLECTIBLES
###############

func add_collectible( collectible, pos ):
	collectibles.add_child( collectible )
	collectible.set_pos( pos )

func remove_collectible( collectible ):
	collectibles.remove_child( collectible )
	collectible.queue_free()


###############
# ENNEMIES
###############

func add_enemy( enemy, pos ):
	enemies.add_child( enemy)
	enemy.set_pos( pos )


func remove_enemy( enemy ):
	enemies.remove_child( enemy )
	enemy.queue_free()