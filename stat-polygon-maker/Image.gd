extends Sprite2D

##CONFIG start
const STARTING_N = 6									##Default number of vertices
const AA = true											##AntiAliasing
const R := 250.0										##Radius of circumscribed circle
const IMG_SIZE = Vector2(800, 800)						##Image resolution

const BG_COLOR = Color.GHOST_WHITE
const POLY_COLOR = Color.GHOST_WHITE
const STATS_COLOR = Color.LIGHT_BLUE
const LINES_COLOR = Color.BLACK
const STATS_LINES_COLOR = Color.NAVY_BLUE

const LABELS_DISTANCE = 10								##Distance of labels from vertices
const AVG_POSITION = IMG_SIZE - Vector2 (75, 90)		##Position of the average
const VALUE_SCALE = 10									##Determines the scale of the value polygon 
##CONFIG end


const label_base = preload("res://label_base.tscn")

var center = IMG_SIZE/2
var vertices : PackedVector2Array = []
var values_positions : PackedVector2Array = []


func _draw():
	
	##Background
	draw_rect(Rect2(Vector2(0,0), IMG_SIZE), BG_COLOR)
	##Polygon
	draw_colored_polygon(vertices,POLY_COLOR)
	##Stats
	draw_colored_polygon(values_positions, STATS_COLOR)
	##Stats Line
	draw_polyline(values_positions, STATS_LINES_COLOR, 2, AA)
	##Polygon Edges
	draw_polyline(vertices, LINES_COLOR, 8, AA)
	##Separation lines
	for i in vertices:
		draw_line( center, i, LINES_COLOR, 2, AA)
	
	
func redraw(N : int, values : Array, names : Array):
	
	##frees previous values
	vertices = []
	values_positions = []
	for i in get_children():
		i.queue_free()
	
	for i in N:
		##sets drawing vectors
		var angle =  PI * 2 * i / N
		vertices.append(Vector2 (center[0] + R * sin(angle), 
								center[1] - R * cos(angle) ))
								
		var lenght = R * values[i] / VALUE_SCALE
		values_positions.append(Vector2 (center[0] + lenght * sin(angle), 
								center[1] - lenght * cos(angle) ))
		
		##sets names and values
		if globals.show_names || globals.show_values:	
			set_label (names[i], values[i], angle)
		
	vertices.append(vertices[0])
	values_positions.append(values_positions[0])
	
	##show average
	if globals.show_avg:
		var l = label_base.instantiate()
		add_child(l)
		l.text = "Average:\n" + str(snapped(globals.avg(values), 0.01))
		await get_tree().process_frame
		l.position = AVG_POSITION
					
					
	await get_tree().process_frame
	queue_redraw()
	
	
func set_label (lname, lvalue, angle):
	var l = label_base.instantiate()
	add_child(l)
	
	if globals.show_names && globals.show_values:
		l.text = lname + "\n" + str(lvalue)
	elif globals.show_values:
		l.text = str(lvalue)
	elif globals.show_names:
		l.text = lname
	
	l.position = Vector2 (center[0] + (R+LABELS_DISTANCE) * sin(angle), 
						center[1] - (R+LABELS_DISTANCE) * cos(angle)) 
	
	
	##small adjustments to position
	##to account for origin being top right corner
	l.position.y  -= l.size.y * (cos(angle)+1)/2		
	
	if (PI < angle and angle < 2 * PI):
		l.position.x -= 2 * LABELS_DISTANCE
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	elif (0 < angle and angle < PI):
		l.position.x += 2 * LABELS_DISTANCE
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
