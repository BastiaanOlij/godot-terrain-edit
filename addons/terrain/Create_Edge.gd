extends MeshInstance

func create_mesh():
	var arrays = Array()
	var vertices = PoolVector3Array()
	var indices = PoolIntArray()
	var idx = 0
	var last_top_idx = 1
	var last_bottom_idx = 4
	
	var pos = -96.0
	
	# create our left corner rectangles
	vertices.push_back(Vector3(0.5, 0.0, pos)) # 0
	vertices.push_back(Vector3(0.5, 0.0, pos + 3.0)) # 1
	vertices.push_back(Vector3(-0.5, 0.0, pos + 1.0)) # 2
	vertices.push_back(Vector3(-0.5, 0.0, pos + 2.0)) # 3
	vertices.push_back(Vector3(-0.5, 0.0, pos + 3.0)) # 4
	
	indices.push_back(0)
	indices.push_back(1)
	indices.push_back(2)
	indices.push_back(1)
	indices.push_back(3)
	indices.push_back(2)
	indices.push_back(1)
	indices.push_back(4)
	indices.push_back(3)
	
	idx += 5
	pos += 3.0
	
	for i in range(0,62):
		vertices.push_back(Vector3(0.5, 0.0, pos + 3.0)) # idx
		vertices.push_back(Vector3(-0.5, 0.0, pos + 1.0)) # idx + 1
		vertices.push_back(Vector3(-0.5, 0.0, pos + 2.0)) # idx + 2
		vertices.push_back(Vector3(-0.5, 0.0, pos + 3.0)) # idx + 3
		
		indices.push_back(last_top_idx)
		indices.push_back(idx + 1)
		indices.push_back(last_bottom_idx)
		indices.push_back(last_top_idx)
		indices.push_back(idx)
		indices.push_back(idx + 1)
		indices.push_back(idx)
		indices.push_back(idx + 2)
		indices.push_back(idx + 1)
		indices.push_back(idx)
		indices.push_back(idx + 3)
		indices.push_back(idx + 2)
		
		last_top_idx = idx
		last_bottom_idx = idx + 3
		idx += 4
		pos += 3.0
	
	# and create our right triangles
	vertices.push_back(Vector3(0.5, 0.0, pos + 3.0)) # idx
	vertices.push_back(Vector3(-0.5, 0.0, pos + 1.0)) # idx + 1
	vertices.push_back(Vector3(-0.5, 0.0, pos + 2.0)) # idx + 2
	indices.push_back(last_top_idx)
	indices.push_back(idx + 1)
	indices.push_back(last_bottom_idx)
	indices.push_back(last_top_idx)
	indices.push_back(idx)
	indices.push_back(idx + 1)
	indices.push_back(idx)
	indices.push_back(idx + 2)
	indices.push_back(idx + 1)
	
	# and build our arrays
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_INDEX] = indices
	
	# and create our mesh
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	new_mesh.custom_aabb = AABB(Vector3(-0.5, 0.0, -96.0), Vector3(1.0, 2048.0, 192.0))
	mesh = new_mesh
	
#	var res_save = ResourceSaver()
	ResourceSaver.save("edge.mesh",new_mesh, ResourceSaver.FLAG_RELATIVE_PATHS)


func _ready():
#	create_mesh()
	pass

