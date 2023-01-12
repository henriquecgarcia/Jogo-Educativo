extends GridContainer

var font = DynamicFont.new()
var added = []
var size = Vector2(320, 50)

func _ready():
	font.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
	font.size = 96/3
	# warning-ignore:return_value_discarded
	Credits.connect("credits_added", self, "add_stuff")
	for i in Credits.credits:
		add_stuff(i)

func add_stuff(text : = "Batata" ):
	if text in added:
		return
	add_text(text)
	
	added.append(text)

func add_text(txt):
	if get_child_count() > 0:
		var rec = ColorRect.new()
		
		rec.color = Color(0.1, 0.1, 0.1, .75)
		rec.rect_min_size = Vector2(0, 5)
		
		add_child(rec)
	
	var lab = Label.new()
	lab.add_font_override("font", font)
	lab.align = Label.ALIGN_CENTER
	lab.autowrap = true
	lab.text = txt
	lab.rect_scale = Vector2(0.1, 0.1)
	lab.rect_min_size = size
	add_child(lab)
