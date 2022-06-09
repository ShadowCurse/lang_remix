#ifndef TEST_COLLISION
#define TEST_COLLISION

#include <gtest/gtest.h>
#include <raylib.h>

#include "box.hpp"
#include "collision.hpp"
#include "scene.hpp"

using collision::Collision;

TEST(box, collision) {
  auto box1 = Box({10, 10}, {10, 10}, 0, RED);
  ASSERT_FALSE(box1.collision(&box1));

  {
    auto box1_clone = Box({10, 10}, {10, 10}, 0, RED);
    ASSERT_FALSE(box1.collision(&box1_clone));
  }

  {
    auto box2 = Box({20, 10}, {10, 10}, 0, RED);
    ASSERT_FALSE(box1.collision(&box2));
  }

  // box to the right
  {
    auto box2 = Box({18, 10}, {10, 10}, 0, RED);
    const auto collision = box1.collision(&box2);
    ASSERT_TRUE(collision);
    const auto col = Collision{{15, 10}, {1.0, 0}};
    ASSERT_EQ(collision.value(), col);
  }

  // box to the left
  {
    auto box2 = Box({8, 10}, {10, 10}, 0, RED);
    const auto collision = box1.collision(&box2);
    ASSERT_TRUE(collision);
    const auto col = Collision{{5, 10}, {-1.0, 0}};
    ASSERT_EQ(collision.value(), col);
  }

  // box above
  {
    auto box2 = Box({10, 8}, {10, 10}, 0, RED);
    const auto collision = box1.collision(&box2);
    ASSERT_TRUE(collision);
    const auto col = Collision{{10, 5}, {0, -1.0}};
    ASSERT_EQ(collision.value(), col);
  }

  // box bellow
  {
    auto box2 = Box({10, 18}, {10, 10}, 0, RED);
    const auto collision = box1.collision(&box2);
    ASSERT_TRUE(collision);
    const auto col = Collision{{10, 15}, {0, 1.0}};
    ASSERT_EQ(collision.value(), col);
  }
};

TEST(scene, collision) {
  auto scene = Scene({100, 100}, {200, 200}, 2, RED);
  
  // box inside scene
  {
    auto box = Box({10, 10}, {10, 10}, 0, RED);
    const auto collision = scene.collision(&box);
    ASSERT_FALSE(collision);
  }

  // box collision right
  {
    auto box = Box({200, 100}, {10, 10}, 0, RED);
    const auto collision = scene.collision(&box);
    ASSERT_TRUE(collision);
    const auto col = Collision{{200, 100}, {-1.0, 0}};
    ASSERT_EQ(collision.value(), col);
  }

  // box collision left
  {
    auto box = Box({0, 100}, {10, 10}, 0, RED);
    const auto collision = scene.collision(&box);
    ASSERT_TRUE(collision);
    const auto col = Collision{{0, 100}, {1.0, 0}};
    ASSERT_EQ(collision.value(), col);
  }

  // box collision top
  {
    auto box = Box({100, 0}, {10, 10}, 0, RED);
    const auto collision = scene.collision(&box);
    ASSERT_TRUE(collision);
    const auto col = Collision{{100, 0}, {0, 1.0}};
    ASSERT_EQ(collision.value(), col);
  }
  // box collision bot
  {
    auto box = Box({100, 200}, {10, 10}, 0, RED);
    const auto collision = scene.collision(&box);
    ASSERT_TRUE(collision);
    const auto col = Collision{{100, 200}, {0, -1.0}};
    ASSERT_EQ(collision.value(), col);
  }
};

#endif  // !TEST_COLLISION
