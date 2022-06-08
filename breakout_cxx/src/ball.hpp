#ifndef BREAKOUT_BALL
#define BREAKOUT_BALL

#include "box.hpp"
#include "collision.hpp"
#include "crates.hpp"
#include "platform.hpp"
#include "raylib.h"
#include "raymath.h"

class Ball : public Box {
 public:
  Ball(Vector2 pos, Vector2 size, Color color, Vector2 velocity, float speed)
      : Box(pos, size, 0, color), _velocity{velocity}, _speed{speed} {}

  auto update(Scene &scene, Platform &platform, CratePack &crates,
              float dt) noexcept -> void {
    this->_rect.move(Vector2Scale(this->_velocity, this->_speed * dt));

    this->check_collision(&scene);
    this->check_collision(&platform);
    this->check_collision(&crates);
  }

 private:
  auto check_collision(Collider *collider) noexcept -> void {
    if (const auto collision = collider->collision(this))
      this->apply_collision(collision.value());
  }
  auto apply_collision(Collision collision) noexcept -> void {
    if (collision.normal.x != 0.0) {
      this->_velocity.x *= -1.0;
    }
    if (collision.normal.y != 0.0) {
      this->_velocity.y *= -1.0;
    }
  }

 private:
  Vector2 _velocity;
  float _speed;
};

#endif  // !BREAKOUT_BALL
