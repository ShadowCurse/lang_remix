Box :: struct {
  rect: Rectangle;
  color:    Color;
}

new_box :: (center: Vector2, size: Vector2, color: Color) -> Box {
  return .{ new_rect(center, size), color };
}

draw :: (box: *Box) {
  DrawRectangleRec(box.rect, box.color);
}

Math :: #import "Math";
#import,file "raylib.jai";
#import,file "collision.jai";
