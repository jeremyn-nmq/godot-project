extends Control
@onready var http_request = $MarginContainer/VBoxContainer/Go/HTTPRequest

var url = "https://empty-parking-lot-detection-jeremys-projects-cce1bf08.vercel.app/api/getParkingMap"

func _on_go_pressed():
	http_request.request(url)




func _on_quit_pressed():
	get_tree().quit()


func _on_http_request_request_completed(result, response_code, headers, body):
	Global.data = JSON.parse_string(body.get_string_from_utf8())
	get_tree().change_scene_to_file("res://final.tscn")
	
