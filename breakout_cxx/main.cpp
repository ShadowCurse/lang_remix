#include <cmath>
#include <iostream>
#include <optional>
#include <vector>

#include "raylib.h"
#include "raymath.h"

constexpr int WIDTH = 800;
constexpr int HEIGHT = 450;
constexpr int TARGET_FPS = 80;
constexpr Color BACKGROUND_COLOR = BLACK;
constexpr Color SCENE_OUTLINE_COLOR = LIGHTGRAY;
constexpr Color PLATFORM_COLOR = RED;
constexpr Color BALL_COLOR = GREEN;
constexpr Color CRATE_COLOR = GREY;

class Box {
 public:
  enum class CollisionType {
    None,
    Top,
    Bot,
    Left,
    Right,
  };

  struct Hit {
    Vector2 pos;
    Vector2 delta;
    Vector2 normal;
  };

 public:
  Box(Vector2 pos, Vector2 size, int line_thick, Color color)
      : _pos{pos}, _size{size}, _line_thick{line_thick}, _color{color} {}

  auto draw() const noexcept -> void {
    DrawRectangleRec(this->rect(), this->_color);
  }

  auto draw_lines() const noexcept -> void {
    DrawRectangleLinesEx(this->rect(), this->_line_thick, this->_color);
  }

  [[nodiscard]] auto collision(const Box *other) const noexcept
      -> std::optional<Hit> {
    const auto dx = other->_pos.x - this->_pos.x;
    const auto px =
        (other->_size.x / 2.0f + this->_size.x / 2.0f) - std::abs(dx);
    if (px <= 0) return std::nullopt;

    const auto dy = other->_pos.y - this->_pos.y;
    const auto py =
        (other->_size.y / 2.0f + this->_size.y / 2.0f) - std::abs(dy);
    if (py <= 0) return std::nullopt;

    auto hit = Hit{};
    if (px < py) {
      const auto sx = dx < 0 ? -1 : 1;
      hit.delta.x = px * sx;
      hit.normal.x = sx;
      hit.pos.x = this->_pos.x + (this->_size.x / 2.0f * sx);
      hit.pos.y = other->_pos.y;
    } else {
      const auto sy = dy < 0 ? -1 : 1;
      hit.delta.y = py * sy;
      hit.normal.y = sy;
      hit.pos.x = other->_pos.x;
      hit.pos.y = this->_pos.y + (this->_size.y / 2.0f * sy);
    }
    return hit;
  }

  [[nodiscard]] constexpr auto rect() const noexcept -> Rectangle {
    return {this->_pos.x - this->_size.x / 2.0f,
            this->_pos.y - this->_size.y / 2.0f, this->_size.x, this->_size.y};
  }

  [[nodiscard]] constexpr auto left() const noexcept -> float {
    return this->_pos.x - this->_size.x / 2.0;
  }

  [[nodiscard]] constexpr auto right() const noexcept -> float {
    return this->_pos.x + this->_size.x / 2.0;
  }

  [[nodiscard]] constexpr auto top() const noexcept -> float {
    return this->_pos.y - this->_size.y / 2.0;
  }

  [[nodiscard]] constexpr auto bot() const noexcept -> float {
    return this->_pos.y + this->_size.y / 2.0;
  }

  [[nodiscard]] constexpr auto pos() const noexcept -> const Vector2 & {
    return this->_pos;
  }

 protected:
  Vector2 _pos;
  Vector2 _size;
  int _line_thick;
  Color _color;
};

using Scene = Box;

class Crate : public Box {
 public:
  Crate(Vector2 pos, Vector2 size, int line_thick, Color color)
      : Box(pos, size, line_thick, color), _disabled{false} {}

  [[nodiscard]] auto disabled() const noexcept -> bool {
    return this->_disabled;
  }

  auto enble() noexcept -> void { this->_disabled = false; }

  auto disable() noexcept -> void { this->_disabled = true; }

 private:
  bool _disabled;
};

class HittableCrates {
 public:
  HittableCrates(int rows, int cols, Vector2 crate_size, Vector2 crate_offset,
                 Vector2 screen_center) {
    auto rows_half = rows / 2;
    auto cols_half = cols / 2;
    auto screen_offset_x =
        screen_center.x - float(cols) / 2.0f * crate_offset.x + crate_size.x / 2.0f;
    auto screen_offset_y =
        screen_center.y - float(rows) / 2.0f * crate_offset.y + crate_size.y / 2.0f;
    for (auto x{0}; x < cols; x++)
      for (auto y{0}; y < rows; y++)
        this->_crates.push_back(
            Crate({float(x) * crate_offset.x + screen_offset_x,
                   float(y) * crate_offset.y + screen_offset_y},
                  crate_size, 0, CRATE_COLOR));
  }

  auto draw() const noexcept -> void {
    for (const auto &box : this->_crates) {
      if (box.disabled()) continue;
      box.draw();
    }
  }

  [[nodiscard]] auto crates() noexcept -> std::vector<Crate> & {
    return this->_crates;
  }

 private:
  std::vector<Crate> _crates;
};

class Platform : public Box {
 public:
  Platform(Vector2 pos, Vector2 size, Color color, float speed)
      : Box{pos, size, 0, color}, _speed{speed} {}

  auto update(const Scene &scene, float dt) noexcept -> void {
    if (IsKeyDown(KEY_LEFT)) {
      this->_pos.x -= this->_speed * dt;
    }
    if (IsKeyDown(KEY_RIGHT)) {
      this->_pos.x += this->_speed * dt;
    }
    if (this->left() < scene.left())
      this->_pos.x = scene.left() + this->_size.x / 2.0f;
    if (scene.right() < this->right())
      this->_pos.x = scene.right() - this->_size.x / 2.0f;
  }

 private:
  float _speed;
};

class Ball : public Box {
 public:
  Ball(Vector2 pos, Vector2 size, Color color, Vector2 velocity, float speed)
      : Box{pos, size, 0, color}, _velocity{velocity}, _speed{speed} {}

  auto update(const Scene &scene, float dt) noexcept -> void {
    auto last_pos = this->_pos;
    this->_pos = Vector2Add(this->_pos,
                            Vector2Scale(this->_velocity, this->_speed * dt));

    if (this->left() < scene.left() || scene.right() < this->right()) {
      this->_pos = last_pos;
      this->_velocity.x *= -1.0f;
      return;
    }
    if (this->top() < scene.top() || scene.bot() < this->bot()) {
      this->_pos = last_pos;
      this->_velocity.y *= -1.0f;
      return;
    }
  }

  auto crates_collision(HittableCrates &crates) noexcept -> void {
    for (auto &crate : crates.crates()) {
      if (crate.disabled()) continue;
      auto hit = crate.collision(this);
      if (hit.has_value()) {
        crate.disable();
        this->apply_hit(hit.value());
      }
    }
  }

  auto platform_collision(Platform &platform) noexcept -> void {
    auto hit = platform.collision(this);
    if (hit.has_value()) {
      this->apply_hit(hit.value());
    }
  }

 private:
  auto apply_hit(Box::Hit &hit) noexcept -> void {
    if ((this->_velocity.x < 0.0f && 0.0f < hit.normal.x) ||
        (0.0f < this->_velocity.x && hit.normal.x < 0.0f)) {
      this->_velocity.x *= -1.0f;
    }
    if ((this->_velocity.y < 0.0f && 0.0f < hit.normal.y) ||
        (0.0f < this->_velocity.y && hit.normal.y < 0.0f)) {
      this->_velocity.y *= -1.0f;
    }
  }

 private:
  Vector2 _velocity;
  float _speed;
};

class GameCamera {
 public:
  enum class FollowMode {
    NoFollow,
    FollowPlayer,
    FollowBall,
  };

  GameCamera(Camera2D camera) : camera{camera}, mode{FollowMode::NoFollow} {}

  auto update(const Platform &player) noexcept -> void {
    switch (this->mode) {
      case FollowMode::NoFollow:
        break;
      case FollowMode::FollowPlayer: {
        this->camera.target.x = player.pos().x;
        break;
      }
      default:
        break;
    }
  }
  auto begin_mode_2d() const { BeginMode2D(this->camera); }
  auto end_mode_2d() const { EndMode2D(); }

 private:
  Camera2D camera;
  FollowMode mode;
};

auto main() -> int {
  InitWindow(WIDTH, HEIGHT, "raylib [core] example - basic window");
  SetTargetFPS(TARGET_FPS);

  auto scene =
      Scene({WIDTH * 0.5, HEIGHT * 0.5}, {WIDTH, HEIGHT}, 2, SCENE_OUTLINE_COLOR);

  auto platform =
      Platform({WIDTH * 0.5, HEIGHT * 0.8}, {100.0, 20.0}, PLATFORM_COLOR, 500.0);

  auto game_camera = GameCamera(Camera2D{
      .offset = {WIDTH * 0.5, HEIGHT * 0.5},
      .target = {platform.pos().x, HEIGHT * 0.5},
      .rotation = 0.0,
      .zoom = 1.0,
  });

  auto hittable_crates = HittableCrates(3, 4, {70.0, 30.0}, {110.0, 80.0},
                                        {WIDTH * 0.5, HEIGHT * 0.2});

  auto ball =
      Ball({WIDTH * 0.5, HEIGHT * 0.5}, {30.0, 30.0}, BALL_COLOR, {1.4, 1.0}, 100.0);

  while (!WindowShouldClose()) {
    auto dt = GetFrameTime();

    platform.update(scene, dt);
    game_camera.update(platform);
    ball.update(scene, dt);

    ball.crates_collision(hittable_crates);
    ball.platform_collision(platform);

    BeginDrawing();
    ClearBackground(BACKGROUND_COLOR);
    game_camera.begin_mode_2d();

    scene.draw_lines();
    hittable_crates.draw();
    ball.draw();
    platform.draw();

    game_camera.end_mode_2d();
    EndDrawing();
  }

  CloseWindow();

  return 0;
}
