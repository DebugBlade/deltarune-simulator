##unused resource 
class_name CharacterInfo
extends Resource

enum ID {NONE, KRIS, SUSIE, RALSEI, NOELLE}

@export_group("Info")
@export var id: ID
@export var name: String
@export var color: Color

@export_group("Assets")
