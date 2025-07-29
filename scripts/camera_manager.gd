extends Node
class_name CameraManager

@export var phantom_cameras: Array[PhantomCamera2D] = []
@export var camera_zone_areas: Array[CameraZoneArea] = []
@export var current_camera: PhantomCamera2D

func _ready() -> void:
	if !current_camera:
		printerr("Current camera is not set. Please assign a camera in the editor.")

	for area in camera_zone_areas:
		area.connect("body_entered", _on_camera_zone_entered.bind(area))

func switch_camera(from_camera: PhantomCamera2D, to_camera: PhantomCamera2D) -> void:
	if from_camera and to_camera:
		current_camera = to_camera
		for camera in phantom_cameras:
			camera.priority = 0
		from_camera.priority = 0
		to_camera.priority = 1
		# print("Switched camera from", from_camera.name, "to", to_camera.name)
	else:
		print("Invalid cameras provided for switching.")

func _on_camera_zone_entered(body: Node, area: CameraZoneArea) -> void:
	if body.is_in_group("main_character"):
		var from_camera : PhantomCamera2D = null
		var to_camera : PhantomCamera2D = null
		if not area.camera_a or not area.camera_b:
			printerr("Camera zone area does not have both cameras assigned.")
			return

		if current_camera == area.camera_a:
			from_camera = area.camera_a
			to_camera = area.camera_b
		elif current_camera == area.camera_b:
			from_camera = area.camera_b
			to_camera = area.camera_a
		else:
			printerr("Current camera is not part of the camera zone area.")
			return
		
		# print("Camera zone entered by main character:", body.name, "Switching from camera: ", from_camera.name, " to ", to_camera.name)
		switch_camera(from_camera, to_camera)