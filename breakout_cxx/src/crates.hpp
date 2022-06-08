#ifndef BREAKOUT_CRATES
#define BREAKOUT_CRATES

#include <vector>

#include "box.hpp"
#include "collision.hpp"
#include "raylib.h"

using collision::Collider;
using collision::Collision;

class Crate final : public Box {
 public:
  Crate(Vector2 pos, Vector2 size, Color color)
      : Box(pos, size, 0.0, color), _disabled{false} {}

  [[nodiscard]] auto disabled() const noexcept -> bool {
    return this->_disabled;
  }

  auto disable() noexcept -> void { this->_disabled = true; }

 private:
  bool _disabled;
};

class CratePack final : public Collider {
 public:
  CratePack(Vector2 pos, int rows, int cols, float width, float height,
            float gap_x, float gap_y, Color color) {
    if (rows % 2 == 0) {
      pos.y += (gap_y / 2.0 + height / 2.0) -
               (gap_y + height) * (float(rows - 1) / 2);
    } else {
      pos.y += (gap_y + height) * (float(rows - 1) / 2);
    }
    if (cols % 2 == 0) {
      pos.x -=
          (gap_x / 2.0 + width / 2.0) + (gap_x + width) * (float(cols - 1) / 2);
    } else {
      pos.x -= (gap_x + width) * (float(cols - 1) / 2);
    }

    for (auto x{0}; x < cols; x++) {
      for (auto y{0}; y < rows; y++) {
        const auto crate_pos = Vector2{
            pos.x + x * (width + gap_x),
            pos.y + y * (height + gap_y),
        };
        const auto crate = Crate(crate_pos, {width, height}, color);
        this->_crates.push_back(crate);
      }
    }
  }

  [[nodiscard]] auto collision(const Collider *other) noexcept
      -> std::optional<Collision> final {
    for (auto &c : this->_crates) {
      if (c.disabled()) continue;
      if (const auto collision = c.collision(other)) {
        c.disable();
        return collision;
      }
    }
    return std::nullopt;
  }

  auto draw() const noexcept -> void {
    for (const auto &c : this->_crates) {
      if (c.disabled()) continue;
      c.draw();
    }
  }

 private:
  std::vector<Crate> _crates;
};

#endif  // !BREAKOUT_CRATES
