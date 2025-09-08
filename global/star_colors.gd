class_name StellarColors extends Node

const COLORS := [[2300, "fe7d24"], [2400, "fe842d"], [2500, "fe8a33"], [2600, "fe9a41"], [2700, "fea548"], [2800, "fea548"], [2900, "fea448"], [3000, "fea349"], [3100, "fea24a"], [3200, "fea24c"], [3300, "fea24e"], [3400, "fea250"], [3500, "fea251"], [3600, "fea153"], [3700, "fea256"], [3800, "fea158"], [3900, "fea25a"], [4000, "fea35e"], [4100, "fea563"], [4200, "fea868"], [4300, "feac6f"], [4400, "feb177"], [4500, "feb67f"], [4600, "febc87"], [4700, "fec18f"], [4800, "fec797"], [4900, "fecc9f"], [5000, "fed1a7"], [5100, "fed6b0"], [5200, "fedab8"], [5300, "fedec0"], [5400, "fee1c7"], [5500, "fee5cf"], [5600, "fee8d7"], [5700, "fee6d4"], [5800, "feede6"], [5900, "feefed"], [6000, "fef2f6"], [6100, "fef4fe"], [6200, "f3edfe"], [6300, "ebe7fe"], [6400, "e4e3fe"], [6500, "dddefe"], [6600, "d7d9fe"], [6700, "d1d6fe"], [6800, "ccd2fe"], [6900, "c7cffe"], [7000, "c2cbfe"], [7200, "b8c5fe"], [7400, "b0bffe"], [7600, "abbcfe"], [7800, "a2b5fe"], [8000, "9ab0fe"], [8200, "93aafe"], [8400, "8da6fe"], [8600, "8ba4fe"], [8800, "87a1fe"], [9000, "849ffe"], [9200, "819dfe"], [9400, "7f9bfe"], [9600, "7d99fe"], [9800, "7b97fe"], [10000, "7996fe"], [10200, "7895fe"], [10400, "7794fe"], [10600, "7693fe"], [10800, "7592fe"], [11000, "7491fe"], [11200, "7391fe"], [11400, "7290fe"], [11600, "7290fe"], [11800, "728ffe"], [12000, "718ffe"], [12500, "708efe"], [13000, "6f8dfe"], [13500, "6e8cfe"], [14000, "6d8bfe"], [14500, "6c8afe"], [15000, "6b89fe"], [16000, "6988fe"], [17000, "6887fe"], [18000, "6686fe"], [19000, "6585fe"], [20000, "6484fe"], [21000, "6383fe"], [22000, "6283fe"], [23000, "6182fe"], [24000, "6181fe"], [25000, "6081fe"], [26000, "5f80fe"], [27000, "5f80fe"], [27500, "5e7ffe"], [28000, "5e7ffe"], [29000, "5d7ffe"], [30000, "5c7dfe"], [32500, "5c7dfe"], [35000, "5b7cfe"], [37500, "5b7cfe"], [40000, "5b7bfe"], [42500, "5a7bfe"], [45000, "5a7bfe"], [47500, "5b7bfe"], [50000, "5b7bfe"], [52500, "5b7cfe"], [55000, "5c7cfe"]]

const BROWN_DWARF_EXTRAPOLATE := [[798,"000000"],[873,"0C0601"],[948,"190C03"],[1023,"261205"],[1098,"321907"],[1173,"3F1F09"],[1248,"4C250A"],[1323,"582B0C"],[1398,"65320E"],[1473,"723810"],[1549,"7F3E12"],[1624,"8B4413"],[1699,"984B15"],[1774,"A55117"],[1849,"B15719"],[1924,"BE5D1B"],[1999,"CB641C"],[2074,"D76A1E"],[2149,"E47020"]]

func get_color_from_temp(temp:float):
	var merge_lists = COLORS.duplicate() + BROWN_DWARF_EXTRAPOLATE.duplicate()
	merge_lists.sort()

	var diff_lists = []
	for idx in merge_lists.size():
		var diff = temp - merge_lists[idx][0]
		diff_lists.append(abs(diff))
	var smallest_possible_diff = _get_smallest_possible_difference(diff_lists.duplicate())
	
	for idx in diff_lists.size():
		if diff_lists[idx] == smallest_possible_diff:
			return merge_lists[idx][1]

func _get_smallest_possible_difference(array:Array):
	array.sort()
	array.resize(1)
	return array[0]

func _ready() -> void:
	pass
