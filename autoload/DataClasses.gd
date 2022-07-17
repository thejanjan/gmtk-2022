extends Node


"""
Various data classes.
"""


class CoinData:
	
	var heads;  # item ID
	var tails;  # item ID
	
	func _init(heads: int, tails: int):
		self.heads = heads
		self.tails = tails
		
	func flip_coin() -> int:
		return Random.choice([self.heads, self.tails])
		
	func get_heads():
		return self.heads
		
	func get_tails():
		return self.tails
