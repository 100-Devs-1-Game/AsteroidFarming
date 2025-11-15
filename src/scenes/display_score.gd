class_name DisplayScore extends RichTextLabel


func display_score(data:Dictionary):
	var texts:Array[String]=[]
	var keys:Array[String]=["score","harvested","lost"]
	for key in keys:
		var strkey:=key.capitalize()
		var value:String=str(data[key]) if key in data else "N/A"
		var line:String=strkey+": "+value
		texts.append(line)
	self.text="\n".join(texts)
