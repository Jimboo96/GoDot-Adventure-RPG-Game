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
var typeOfDialogue

func _ready():
	reset_text(null, null)

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
				if typeOfDialogue != "NPC" && typeOfDialogue != "Quest":
					$DisappearTimer.start()

func reset_text(var typeOfReset, var textID = null):
	printing = false
	donePrinting = false
	currentChar = 0
	currentText = 0
	timer = 0
	if typeOfReset == "NPC":
		typeOfDialogue = "NPC"
		textToPrint = [random_quote()]
	elif typeOfReset == "SignPost" && textID != null:
		typeOfDialogue = "SignPost"
		textToPrint = [jsonData[str(textID)].text]
	elif typeOfReset == "Chest":
		typeOfDialogue = "Chest"
		textToPrint = ["You found:\n" + jsonData[str(textID)].text + "!"]
		get_item(jsonData[str(textID)].itemId)
	elif typeOfReset == "Other" && textID != null:
		typeOfDialogue = "Other"
		textToPrint = [jsonData[str(textID)].text]
	elif typeOfReset == "Quest" && textID != null:
		typeOfDialogue = "Quest"
		textToPrint = [jsonData[str(textID)].text]
	self.bbcode_text = ""
	self.hide()

func _physics_process(delta):
	print_dialogue(delta)
	
func json_line_reader(var type):
	var data_file = File.new()
	if data_file.open("res://json/" + type + "_lines.json", File.READ) != OK:
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
	json_line_reader("NPC")
	reset_text("NPC")
	self.show()
	printing = true

func start_chest_dialogue(var chestNum, var areaName):
	json_line_reader("Chest")
	var chestID
	if areaName == "area1": chestID = 0
	elif areaName == "area2": chestID = 2
	elif areaName == "area3": chestID = 5
	elif areaName == "secretArea": chestID = 7
	elif areaName == "house1": chestID = 8
	chestID += chestNum
	reset_text("Chest", chestID)
	self.show()
	printing = true

func _on_SwitchArea_start_dialogue():
	var textID
	var textType
	if global.current_area == "area1":
		textID = 1
		textType = "Other"
	elif global.current_area == "area2": 
		textID = 1
		textType = "SignPost"
	elif global.current_area == "area3": 
		textID = 2
		textType = "SignPost"
	elif global.current_area == "secretArea": 
		textID = 2
		textType = "Other"
	json_line_reader(textType)
	reset_text(textType, textID)
	self.show()
	printing = true

func _on_DisappearTimer_timeout():
	reset_text(null, null)

func _on_SwitchArea2_start_dialogue():
	var textID
	var textType
	if global.current_area == "area2": 
		textID = 3
		textType = "Other"
	json_line_reader(textType)
	reset_text(textType, textID)
	self.show()
	printing = true

func quest_dialogue(var textID):
	json_line_reader("Quest")
	reset_text("Quest", textID)
	self.show()
	printing = true
	
func get_item(var id):
		global.reward(id)
	
