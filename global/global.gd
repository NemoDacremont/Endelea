extends Node

const NUM_OF_COINS: int = 2

const FADING_DURATION: float = 1.0  # in s
const DREAM_FADING_COLOR: Color = Color(0.875, 0.973, 1, 1);
const DREAM_FADING_IN_COLOR: Color = Color(0.875, 0.973, 1, 1);
const DREAM_FADING_OUT_COLOR: Color = Color(0.875, 0.973, 1, 0);

const NIGHTMARE_FADING_COLOR: Color = Color(0.341, 0, 0.098, 1);
const NIGHTMARE_FADING_IN_COLOR: Color = Color(0.341, 0, 0.098, 1);
const NIGHTMARE_FADING_OUT_COLOR: Color = Color(0.341, 0, 0.098, 0);


const MAIN_SCENE: String = "res://main.tscn"

const FADING_PATH: String = "res://UI/fading/fading.tscn"

var number_of_coins: int = 0
var time: float = 0


func init():
	number_of_coins = 0
	time = 0


