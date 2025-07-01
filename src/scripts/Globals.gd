extends Node

## PREFERENCES
@onready var tileScheme:String = '_alt'

@onready var move:int = 1
@onready var activePlayer:String = 'bot'
@onready var activeColour:String = 'white'

@onready var whitePlayer:String = 'gmharper'
@onready var blackPlayer:String = 'computer'

@onready var whiteMove:int = 1
@onready var blackMove:int = 1
@onready var whiteTime:int = 0
@onready var blackTime:int = 0

@onready var matchTime:int = 0

@onready var validSpace:bool = false
@onready var validBoardSpace:bool = false

@onready var activeIndex:String = ''

@onready var holding:bool = false
@onready var holdingTile:Node
@onready var holdingTileType:String = ''
@onready var holdingOrientation:String = 'top'
