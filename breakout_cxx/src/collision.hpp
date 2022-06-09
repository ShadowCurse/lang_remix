#ifndef BREAKOUT_COLLISION
#define BREAKOUT_COLLISION

#include <optional>

#include "raylib.h"

namespace collision {

struct Collision {
  Vector2 pos;
  Vector2 normal;
  
  [[nodiscard]] constexpr inline auto operator==(const Collision& other) const noexcept -> bool {
    return this->pos.x == other.pos.x &&
           this->pos.y == other.pos.y &&
           this->normal.x == other.normal.x &&
           this->normal.y == other.normal.y;
          
  }
};

struct Rect {
  Rect(Vector2 pos, Vector2 size) {
    this->rect = Rectangle{
        pos.x - size.x / 2.0f,
        pos.y - size.y / 2.0f,
        size.x,
        size.y,
    };
  }

  [[nodiscard]] constexpr inline operator Rectangle() const noexcept {
    return this->rect;
  }

  [[nodiscard]] constexpr inline auto operator==(
      const Rect& other) const noexcept -> bool {
    return this->rect.x == other.rect.x && this->rect.y == other.rect.y &&
           this->rect.width == other.rect.width &&
           this->rect.height == other.rect.height;
  }

  constexpr inline auto set_pos(Vector2 vec) noexcept {
    this->rect.x = vec.x - this->rect.width / 2.0f;
    this->rect.y = vec.y - this->rect.height / 2.0f;
  }

  constexpr inline auto move(Vector2 vec) noexcept {
    this->rect.x += vec.x;
    this->rect.y += vec.y;
  }

  [[nodiscard]] constexpr inline auto pos() const noexcept -> Vector2 {
    return {this->rect.x + this->rect.width / 2.0f,
            this->rect.y + this->rect.height / 2.0f};
  }

  [[nodiscard]] constexpr inline auto width() const noexcept -> float {
    return this->rect.width;
  }

  [[nodiscard]] constexpr inline auto height() const noexcept -> float {
    return this->rect.height;
  }

  [[nodiscard]] constexpr inline auto top() const noexcept -> float {
    return this->rect.y;
  }

  [[nodiscard]] constexpr inline auto bot() const noexcept -> float {
    return this->rect.y + this->rect.height;
  }

  [[nodiscard]] constexpr inline auto left() const noexcept -> float {
    return this->rect.x;
  }

  [[nodiscard]] constexpr inline auto right() const noexcept -> float {
    return this->rect.x + this->rect.width;
  }

  Rectangle rect;
};

struct Collider {
  [[nodiscard]] virtual auto rect() const noexcept -> std::optional<Rect> {
    return std::nullopt;
  }
  [[nodiscard]] virtual auto collision(const Collider* other) noexcept
      -> std::optional<Collision> = 0;
};

}  // namespace collision

#endif  // !BREAKOUT_COLLISION
