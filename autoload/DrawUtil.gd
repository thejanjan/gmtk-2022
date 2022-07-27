tool
extends Node

static func draw_circle_arc(canvas_node: CanvasItem, offset: Vector2, radius: float, angle_from: float, angle_to: float, color: Color) -> void:
  var nb_points = 32
  var points_arc = PoolVector2Array()

  for i in range(nb_points + 1):
      var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
      points_arc.push_back(offset + radius*Vector2(cos(angle_point), sin(angle_point)))

  for index_point in range(nb_points):
      canvas_node.draw_line(points_arc[index_point], points_arc[index_point + 1], color)