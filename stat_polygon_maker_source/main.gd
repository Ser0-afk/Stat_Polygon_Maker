extends Control


const SUBVIEWPORT_SIZE =  Vector2i(800,800)
var def_theme : Theme = load("res://assets/gui_style/DefaulTheme.tres")

var values := []
var texts := []
var drag : bool = false
var drag_offset:= Vector2(0,0)
@onready var dragging_scene = %Main_Panel

func _ready() -> void:
	
	globals.resize.connect(resize)
	globals.redraw.connect(redraw)
	globals.rebuild.connect(rebuild)
	globals.drag.connect(drag_toogle)

	
	resize()
	rebuild()

##toggles dragging and prevents box being dragged outside of screen 
func drag_toogle(dragging:bool, scene, offset):
	if dragging:
		dragging_scene = scene
		dragging_scene.move_to_front()
		drag_offset = offset
	drag = dragging
	if not dragging:
		if dragging_scene.global_position.x + dragging_scene.size.x < 25:
			dragging_scene.global_position.x = 25 - dragging_scene.size.x
		if dragging_scene.global_position.y + dragging_scene.size.y < 25:
			dragging_scene.global_position.y = 25 - dragging_scene.size.y
			
		if dragging_scene.global_position.x > get_viewport_rect().size.x:
			dragging_scene.global_position.x = get_viewport_rect().size.x - 25
		if dragging_scene.global_position.y> get_viewport_rect().size.y:
			dragging_scene.global_position.y = get_viewport_rect().size.y - 25

##for dragging
func _physics_process(_delta: float) -> void:
	if drag:
		dragging_scene.global_position = get_global_mouse_position() - drag_offset

##resizes image subviewport according to size and scale
func resize():
	var subview_size : Vector2
	
	if ConfigHandler.others["SCALING_ON"]:
		var ratio : float =  float(ConfigHandler.measures["IMG_SIZE"].x)/ ConfigHandler.measures["IMG_SIZE"].y
		
		if ratio >= 1:
			subview_size = Vector2(SUBVIEWPORT_SIZE * ConfigHandler.others["IMG_SCALE"]) * Vector2(1, 1/ratio)
		else :
			subview_size = Vector2(SUBVIEWPORT_SIZE * ConfigHandler.others["IMG_SCALE"]) * Vector2(ratio, 1)
	else:
		subview_size = ConfigHandler.measures["IMG_SIZE"]
	
	
	%SubViewport.size = ConfigHandler.measures["IMG_SIZE"]
	%SubViewportContainer.pivot_offset = %SubViewport.size/2
	%Image.position = Vector2(0, 0)
	
	%SubViewportContainer.scale = subview_size / Vector2(ConfigHandler.measures["IMG_SIZE"])
	
##draws background
func _draw() -> void:
	draw_rect(Rect2(Vector2(0,0), get_viewport().size), 
				ConfigHandler.gui_colors["WINDOW_BG"])

##redraws without changing parameters, for uodating colors only
func redraw():
	queue_redraw()
	%Image.queue_redraw()

##draws polygon
func rebuild() -> void:
	##reset values
	values = []
	texts = []
	
	##gets values
	for i in %Values.get_children():
		values.append(int(i.get_child(1).text))
		texts.append(i.get_child(0).text)
	
	%Image.redraw(int(%NumberSelector.text), values, texts)
