extends Node


"""
A preload file for storing several different types of enums.
"""


enum DiceSide {
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX
}

enum ItemType {
	NIL = -1,
	BASIC_DAMAGE,
	FAST,
	OIL_SLICK,
	RUBBER_OF_THE_SOUL,
	STUNT_DOUBLER,
	BANANA_PEEL
}

enum EnemyFlavor {
	PAWN,
	KNIGHT,
	BISHOP,
	ROOK,
	KING,
	QUEEn
}

enum ItemRarity {
	# item weights defined here
	COMMON = 25,
	RARE = 5,
	SUPERFLUOUS = 1,
}
