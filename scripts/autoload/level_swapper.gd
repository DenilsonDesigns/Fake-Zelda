extends Node


var link: Link

func level_swap(link_to_stash: Link, new_level_string: String) -> void:
	stash_link(link_to_stash)
	get_tree().change_scene_to_file(new_level_string)
	drop_link()

func stash_link(link_to_stash: Link) -> void:
	link = link_to_stash
	link.get_parent().remove_child(link)

func drop_link() -> void:
	await get_tree().create_timer(0).timeout
	var parent := get_tree().current_scene
	parent.add_child(link)
	link.owner = parent

	for transition_door: TransitionDoor in get_tree().get_nodes_in_group("TransitionDoors"):
		if transition_door.connection != link.last_door_connection: continue
		link.global_position = transition_door.drop_point.global_position
