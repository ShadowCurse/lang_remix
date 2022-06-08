#ifndef BREAKOUT_PLATFORM
#define BREAKOUT_PLATFORM

#include <iostream>

#include "box.hpp"
#include "raylib.h"
#include "scene.hpp"

class Platform final : public Box {
 public:
  Platform(Vector2 pos, Vector2 size, Color color, float speed)
      : Box{pos, size, 0, color}, _speed{speed} {}

  auto update(Scene &scene, float dt) noexcept -> void {
    if (IsKeyDown(KEY_LEFT)) {
      this->_rect.move(Vector2{-this->_speed * dt, 0.0});
    }
    if (IsKeyDown(KEY_RIGHT)) {
      this->_rect.move(Vector2{this->_speed * dt, 0.0});
    }

    if (const auto collision = scene.collision(this)) {
      const auto c = collision.value();
      if (0.0 < c.normal.x) {
        this->_rect.set_pos(
            Vector2{c.pos.x + this->_rect.width() / 2.0f, this->_rect.pos().y});
      } else {
        this->_rect.set_pos(
            Vector2{c.pos.x - this->_rect.width() / 2.0f, this->_rect.pos().y});
      }
    }
  }

 private:
  float _speed;
};

#endif  // !BREAKOUT_PLATFORM
