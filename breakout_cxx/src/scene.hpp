#ifndef BREAKOUT_SCENE
#define BREAKOUT_SCENE

#include <optional>

#include "box.hpp"
#include "collision.hpp"

using collision::Collision;

class Scene final : public Box {
 public:
  Scene(Vector2 pos, Vector2 size, float line_tickness, Color color)
      : Box(pos, size, line_tickness, color) {}

  [[nodiscard]] auto collision(const Collider* other) noexcept
      -> std::optional<Collision> final {
    if (this == other) return std::nullopt;

    const auto this_rect_opt = this->rect();
    const auto other_rect_opt = other->rect();

    if (!this_rect_opt.has_value() || !other_rect_opt.has_value())
      return std::nullopt;

    const auto this_rect = this_rect_opt.value();
    const auto other_rect = other_rect_opt.value();

    if (other_rect.left() < this_rect.left()) {
      return Collision{
          Vector2{
              this_rect.left(),
              other_rect.pos().y,
          },
          Vector2{1.0, 0.0},
      };
    } else if (this_rect.right() < other_rect.right()) {
      return Collision{
          Vector2{
              this_rect.right(),
              other_rect.pos().y,
          },
          Vector2{-1.0, 0.0},
      };
    } else if (other_rect.top() < this_rect.top()) {
      return Collision{
          Vector2{
              other_rect.pos().x,
              this_rect.top(),
          },
          Vector2{0.0, 1.0},
      };
    } else if (this_rect.bot() < other_rect.bot()) {
      return Collision{
          Vector2{
              other_rect.pos().x,
              this_rect.bot(),
          },
          Vector2{0.0, -1.0},
      };
    } else {
      return std::nullopt;
    }
  }
};

#endif  // !BREAKOUT_SCENE
