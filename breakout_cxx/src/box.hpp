#ifndef BREAKOUT_BOX
#define BREAKOUT_BOX

#include <cmath>
#include <optional>

#include "collision.hpp"
#include "raylib.h"

using collision::Collider;
using collision::Collision;
using collision::Rect;

class Box : public Collider {
 public:
  Box(Vector2 pos, Vector2 size, int line_thick, Color color)
      : Collider(),
        _rect{Rect(pos, size)},
        _line_thick{line_thick},
        _color{color} {}

  [[nodiscard]] auto rect() const noexcept -> std::optional<Rect> final {
    return this->_rect;
  }

  [[nodiscard]] auto collision(const Collider* other) noexcept
      -> std::optional<Collision> override {
    if (this == other) return std::nullopt;

    const auto this_rect_opt = this->rect();
    const auto other_rect_opt = other->rect();

    if (!this_rect_opt.has_value() || !other_rect_opt.has_value())
      return std::nullopt;

    const auto this_rect = this_rect_opt.value();
    const auto other_rect = other_rect_opt.value();

    if (this_rect == other_rect) return std::nullopt;

    const auto dx = other_rect.pos().x - this_rect.pos().x;
    const auto px =
        (other_rect.width() / 2.0f + this_rect.width() / 2.0f) - std::abs(dx);
    if (px <= 0) return std::nullopt;

    const auto dy = other_rect.pos().y - this_rect.pos().y;
    const auto py =
        (other_rect.height() / 2.0f + this_rect.height() / 2.0f) - std::abs(dy);
    if (py <= 0) return std::nullopt;

    auto collision = Collision{};
    if (px < py) {
      const auto sx = dx < 0 ? -1 : 1;
      collision.normal.x = sx;
      collision.pos.x = this_rect.pos().x + (this_rect.width() / 2.0f * sx);
      collision.pos.y = other_rect.pos().y;
    } else {
      const auto sy = dy < 0 ? -1 : 1;
      collision.normal.y = sy;
      collision.pos.x = other_rect.pos().x;
      collision.pos.y = this_rect.pos().y + (this_rect.height() / 2.0f * sy);
    }
    return collision;
  }

  auto inline draw() const noexcept -> void {
    DrawRectangleRec(this->_rect, this->_color);
  }

  auto inline draw_lines() const noexcept -> void {
    DrawRectangleLinesEx(this->_rect, this->_line_thick, this->_color);
  }

 protected:
  Rect _rect;
  int _line_thick;
  Color _color;
};

#endif  // !BREAKOUT_BOX
