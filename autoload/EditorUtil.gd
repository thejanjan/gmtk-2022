tool
extends Node
# Utility functions to help us hit Utilization Quotas.

# Searches a scene's properties for the named property and gets its value.
# I use this to get the textures stored in enemy scene files.
static func find_scene_property_value(scene: PackedScene, p_name: String):
  var state = scene.get_state()
  for node_idx in range(0, state.get_node_count()):
    for prop_idx in range(0, state.get_node_property_count(node_idx)):
      var name = state.get_node_property_name(node_idx, prop_idx)
      if name == p_name:
        return state.get_node_property_value(node_idx, prop_idx)
  return null 