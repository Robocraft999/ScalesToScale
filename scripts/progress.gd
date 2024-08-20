extends Node

var jump_enabled := false
var double_jump_enabled := false
var dash_enabled := false
var horizontal_scale_enabled := false
var vertical_scale_enabled := false
var time_scale_enabled := false

func disable_all():
	jump_enabled = false
	double_jump_enabled = false
	dash_enabled = false
	horizontal_scale_enabled = false
	vertical_scale_enabled = false
	time_scale_enabled = false
