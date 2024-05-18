@tool
extends MeshInstance3D

@export var update = false
@export var clear_vert_vis = false
var target



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain()
	


func generate_terrain():
	#var myArray = [
		#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
		#[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0], 
		#[0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 0], 
		#[0, 2, 2, 0, 2, 2, 0, 0, 2, 3, 0], 
		#[0, 2, 2, 0, 3, 2, 0, 0, 2, 2, 0], 
		#[0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0], 
		#[0, 2, 2, 0, 2, 3, 0, 0, 2, 2, 0], 
		#[0, 2, 2, 0, 2, 2, 0, 0, 3, 2, 0], 
		#[0, 4, 2, 0, 2, 2, 0, 0, 3, 2, 0], 
		#[0, 0, 0, 0, 2, 3, 0, 0, 2, 2, 0], 
		#[0, 2, 3, 0, 0, 0, 0, 0, 3, 0, 0], 
		#[0, 2, 2, 0, 2, 3, 0, 0, 2, 3, 0], 
		#[0, 2, 3, 0, 3, 2, 0, 0, 3, 2, 0], 
		#[0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0], 
		#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	#]
	
	var myArray = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
		[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0], 
		[0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 0], 
		[0, 2, 2, 0, 2, 2, 0, 0, 2, 3, 0], 
		[0, 2, 2, 0, 3, 2, 0, 0, 2, 2, 0], 
		[0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0], 
		[0, 2, 2, 0, 2, 3, 0, 0, 2, 2, 0], 
		[0, 2, 2, 0, 2, 2, 0, 0, 3, 2, 0], 
		[0, 4, 2, 0, 2, 2, 0, 0, 3, 2, 0], 
		[0, 0, 0, 0, 2, 3, 0, 0, 2, 2, 0], 
		[0, 2, 3, 0, 0, 0, 0, 0, 3, 0, 0], 
		[0, 2, 2, 0, 2, 3, 0, 0, 2, 3, 0], 
		[0, 2, 3, 0, 3, 2, 0, 0, 3, 2, 0], 
		[0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0], 
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	]
	
	if(Global.data):
		myArray = Global.data
		
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(myArray.size() + 1):
		for x in range(myArray[0].size() + 1):
			var y = 0
			surftool.add_vertex(Vector3(x,y,z))
			if(myArray[z-1][x-1] == 1):
				draw_box(Vector3(x,y+0.5,z))
			if(myArray[z-1][x-1] == 2):
				draw_ocupied_lot(Vector3(x,y+0.5,z))
			if(myArray[z-1][x-1] == 3):
				draw_empty_lot(Vector3(x,y+0.1,z))
			if(myArray[z-1][x-1] == 4):
				draw_neareast_empty_lot(Vector3(x,y+0.1,z))	
				target = Vector3(x,y,z)
	
	var zSize = myArray.size()
	var xSize = myArray[0].size()
	var vert = 0
	for z in range(zSize):
		for x in range(xSize):
			surftool.add_index(vert)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+2)
			vert+=1
		vert+=1
			
	surftool.generate_normals()
	a_mesh = surftool.commit()
	mesh = a_mesh
	
	create_trimesh_collision()
	
	
	
func draw_box(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var box = BoxMesh.new()
	box.set_size(Vector3(1,1,1))
	ins.mesh = box
	ins.create_trimesh_collision()
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(60, 31 , 165, 0.33)
	ins.mesh.surface_set_material(0, material)
	
func draw_ocupied_lot(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var box = BoxMesh.new()
	box.set_size(Vector3(1,1,0.9))
	ins.mesh = box
	ins.create_trimesh_collision()
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(255, 0, 0, 1)
	ins.mesh.surface_set_material(0, material)
	
func draw_empty_lot(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var box = BoxMesh.new()
	box.set_size(Vector3(1.9,0,0.9))
	ins.mesh = box
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 255, 0, 1)
	ins.mesh.surface_set_material(0, material)
	
func draw_neareast_empty_lot(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var box = BoxMesh.new()
	box.set_size(Vector3(1.9,0,0.9))
	ins.mesh = box
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(255, 246, 0, 1)
	ins.mesh.surface_set_material(0, material)
#func draw_map(x,z):
	#var myArray = [
		#[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 
		#[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 
		#[0,1,1,1,0,0,1,1,1,0,0,1,1,1,0],
		#[0,2,1,2,0,0,2,1,2,0,0,2,1,2,0],
		#[0,4,1,2,0,0,2,1,2,0,0,2,1,2,0],
		#[0,2,1,3,0,0,2,1,3,0,0,2,1,2,0],
		#[0,2,1,2,0,0,2,1,2,0,0,2,1,2,0],
		#[0,2,1,2,0,0,2,1,2,0,0,3,1,2,0],
		#[0,2,1,3,0,0,2,1,3,0,0,2,1,2,0],
		#[0,2,1,2,0,0,2,1,2,0,0,2,1,2,0],
		#[0,1,1,1,0,0,1,1,1,0,0,1,1,1,0],
		#[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		#[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	#];

			
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		generate_terrain()
		update = false
		
	if clear_vert_vis:
		for i in get_children():
			i.free()

func _physics_process(delta):
	get_tree().call_group("Car","update_target_location",target)
