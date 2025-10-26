extends Node

##editable from GUI
var show_names := false
var show_values := true
var show_avg := true

func avg(a : Array) -> float:
	var t := 0.0
	for i in a:
		t += float (i)
	return t/a.size()
