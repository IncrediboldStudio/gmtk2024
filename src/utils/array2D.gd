extends RefCounted
class_name Array2D

var _content: Array = []

func get_value(position : Vector2i):
	if(_content.size() - 1 < position.x):
		return null
	if(_content[position.x].size() - 1 < position.y):
		return null
	return _content[position.x][position.y]
	
func set_value(position : Vector2i, data):
	if(_content.size() - 1 < position.x):
		_content.resize(position.x + 1)
	if(_content[position.x].size() - 1 < position.y):
		for x in range(_content.size()):
			_content[x].resize(position.y + 1)
	_content[position.x][position.y] = data
	
func resize(size : Vector2i):
	
	if(_content.size() - 1 < size.x):
		for i in range(_content.size(), size.x):
			_content.append([])
	else:
		_content.resize(size.x)
	for x in range(_content.size()):
		_content[x].resize(size.y)
	return self
		
func fill(data):
	for x in range(_content.size()):
		_content[x].fill(data)
	return self
	
func size_x():
	return _content.size()

func size_y():
	return _content[0].size()
	
#To print properly
func _to_string():
	var result : String = ""
	for y in size_y():
		var row = ""
		for x in size_x():
			row += str(_content[x][y])
		result += row + "\n"
	return result


