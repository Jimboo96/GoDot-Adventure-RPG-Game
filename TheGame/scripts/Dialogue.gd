extends RichTextLabel

const TEXTSPEED = 0.05

var printing = false
var donePrinting = false

var timer = 0
var currentChar = 0
var currentText = 0

var textToPrint
var pressed
var jsonData

func _ready():
	reset_text(null)

func print_dialogue(delta):
	if printing:
		if !donePrinting:
			timer += delta
			if timer > TEXTSPEED:
				timer = 0
				self.bbcode_text += textToPrint[currentText][currentChar]
				currentChar += 1
			if currentChar >= textToPrint[currentText].length():
				currentChar = 0
				timer = 0
				donePrinting = true
				currentText += 1

func reset_text(var typeOfReset):
	printing = false
	donePrinting = false
	currentChar = 0
	currentText = 0
	timer = 0
	if typeOfReset == "NPC":
		textToPrint = [random_quote()]
	elif typeOfReset == "SignPost":
		textToPrint = ["hello"]
	self.bbcode_text = ""
	self.hide()

func _physics_process(delta):
	print_dialogue(delta)

func json_NPC_line_reader():
	var data_file = File.new()
	if data_file.open("res://NPC_lines.json", File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	jsonData = data_parse.result

func random_quote():
	var randomNumber = randi()%10 + 1
	return jsonData[str(randomNumber)].text

func _on_NPC_end_dialogue():
	reset_text("NPC")

func _on_NPC_start_dialogue():
	json_NPC_line_reader()
	reset_text("NPC")
	self.show()
	printing = true
	
func _on_SignPost_start_dialogue():
	if get_tree().get_current_scene().get_name() == "area2":
		reset_text("SignPost")
		self.show()
		printing = true

func _on_SignPost_end_dialogue():
	reset_text("SignPost")
