#include "raylib.h"
#include "raymath.h"
#include <iostream>
#include <vector>

constexpr int WIDTH = 800;
constexpr int HEIGHT = 450;
constexpr Color BACKGROUND = BLACK;
constexpr Color SCENE_OUTLINE = LIGHTGRAY;
constexpr int TARGET_FPS = 110;

class Box {
 public:
  Box(Vector2 pos, Vector2 size, int line_thick, Color color)
      : _pos{pos}, _size{size}, _line_thick{line_thick}, _color{color} {}

  auto draw() const noexcept -> void {
    DrawRectangleRec(this->rect(), this->_color);
  }

  auto draw_lines() const noexcept -> void {
    DrawRectangleLinesEx(this->rect(), this->_line_thick, this->_color);
  }

  constexpr auto rect() const noexcept -> Rectangle {
    return {this->_pos.x - this->_size.x / 2.0f,
            this->_pos.y - this->_size.y / 2.0f, this->_size.x, this->_size.y};
  }

  constexpr auto left() const -> float {
    return this->_pos.x - this->_size.x / 2.0;
  }

  constexpr auto right() const -> float {
    return this->_pos.x + this->_size.x / 2.0;
  }

  constexpr auto top() const -> float {
    return this->_pos.y - this->_size.y / 2.0;
  }

  constexpr auto bot() const -> float {
    return this->_pos.y + this->_size.y / 2.0;
  }

  constexpr auto pos() const -> const Vector2 & { return this->_pos; }

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

  auto disabled() const -> bool { return this->_disabled; }

  auto enble() { this->_disabled = false; }

  auto disable() { this->_disabled = true; }

 private:
  bool _disabled;
};

class HittableCrates {
 public:
  HittableCrates(int rows, int cols, Vector2 box_size, Vector2 box_offset,
                 Vector2 screen_center) {
    auto rows_half = rows / 2;
    auto cols_half = cols / 2;
    auto screen_offset_x =
        screen_center.x - float(cols) / 2.0f * box_offset.x + box_size.x / 2.0f;
    auto screen_offset_y =
        screen_center.y - float(rows) / 2.0f * box_offset.y + box_size.y / 2.0f;
    for (auto x{0}; x < cols; x++)
      for (auto y{0}; y < rows; y++)
        this->_crates.push_back(
            Crate({float(x) * box_offset.x + screen_offset_x,
                   float(y) * box_offset.y + screen_offset_y},
                  box_size, 0, GRAY));
  }

  auto draw() const noexcept -> void {
    for (const auto &box : this->_crates) {
      if (box.disabled()) continue;
      box.draw();
    }
  }

  auto crates() noexcept -> std::vector<Crate> & { return this->_crates; }

 private:
  std::vector<Crate> _crates;
};

class Platform : public Box {
 public:
  Platform(Vector2 pos, Vector2 size, Color color, float speed)
      : Box{pos, size, 0, color}, _speed{speed} {}

  auto update(const Scene &scene, float dt) {
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

  auto update(const Scene &scene, HittableCrates &crates,
              const Platform &platform, float dt) {
    this->_pos =
        Vector2Add(this->_pos, Vector2Scale(this->_velocity, this->_speed));

    if (this->left() < scene.left() || scene.right() < this->right())
      this->_velocity.x *= -1.0f;
    if (this->top() < scene.top() || scene.bot() < this->bot())
      this->_velocity.y *= -1.0f;

    for (auto &crate : crates.crates()) {
      if (crate.disabled()) continue;
      if (this->check_collision(&crate)) crate.disable();
    }
    this->check_collision(&platform);
  }

 private:
  auto check_collision(const Box *box) -> bool {
    // right
    if (this->left() < box->right() && box->right() < this->right() &&
        this->top() < box->bot() && box->top() < this->bot()) {
      this->_velocity.x *= -1.0f;
      return true;
    } else
      // left
      if (this->left() < box->left() && box->left() < this->right() &&
          this->top() < box->bot() && box->top() < this->bot()) {
        this->_velocity.x *= -1.0f;
        return true;
      } else
        // top
        if (this->top() < box->top() && box->top() < this->bot() &&
            this->left() < box->right() && box->left() < this->right()) {
          this->_velocity.y *= -1.0f;
          return true;
        } else
          // bot
          if (this->top() < box->bot() && box->bot() < this->bot() &&
              this->left() < box->right() && box->left() < this->right()) {
            this->_velocity.y *= -1.0f;
            return true;
          }
    return false;
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

  auto update(const Platform &player) {
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

  Camera2D camera;
  FollowMode mode;
};

auto main() -> int {
  InitWindow(WIDTH, HEIGHT, "raylib [core] example - basic window");
  SetTargetFPS(TARGET_FPS);

  auto scene =
      Scene({WIDTH * 0.5, HEIGHT * 0.5}, {WIDTH, HEIGHT}, 2, SCENE_OUTLINE);

  auto platform =
      Platform({WIDTH * 0.5, HEIGHT * 0.8}, {100.0, 20.0}, RED, 500.0);

  auto game_camera = GameCamera(Camera2D{
      .offset = {WIDTH * 0.5, HEIGHT * 0.5},
      .target = {platform.pos().x, HEIGHT * 0.5},
      .rotation = 0.0,
      .zoom = 1.0,
  });

  auto hittable_boxes = HittableCrates(3, 4, {70.0, 30.0}, {110.0, 80.0},
                                       {WIDTH * 0.5, HEIGHT * 0.2});

  auto ball =
      Ball({WIDTH * 0.5, HEIGHT * 0.5}, {30.0, 30.0}, GREEN, {1.4, 1.0}, 2.0);

  while (!WindowShouldClose()) {
    auto dt = GetFrameTime();

    platform.update(scene, dt);
    game_camera.update(platform);
    ball.update(scene, hittable_boxes, platform, dt);

    BeginDrawing();
    ClearBackground(BACKGROUND);
    game_camera.begin_mode_2d();

    scene.draw_lines();
    hittable_boxes.draw();
    ball.draw();
    platform.draw();

    game_camera.end_mode_2d();
    EndDrawing();
  }

  CloseWindow();

  return 0;
}
