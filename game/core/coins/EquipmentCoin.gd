extends Control


"""
A control schema for the Coin.
Also handles the GUI for it.
"""


func _ready():
	GameState.ActiveCoins.append(self)
