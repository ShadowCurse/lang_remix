test_rect :: () {
  rect := new_rect(.{0.0, 0.0}, .{10.0, 10.0});
  assert(pos(rect) == .{0.0, 0.0});
  assert(left(rect) == -5.0);
  assert(right(rect) == 5.0);
  assert(top(rect) == -5.0);
  assert(bot(rect) == 5.0);
}

test_rect_rect_collision :: () {
  rect1 := new_rect(.{0.0, 0.0}, .{10.0, 10.0});
  {
      collision, ok := collides(*rect1, *rect1);
      assert(!ok);
  }

  rect2 := new_rect(.{8.0, 8.0}, .{4.0, 4.0});
  {
      collision, ok := collides(*rect1, *rect2);
      assert(!ok);
  }
  {
      collision, ok := collides(*rect2, *rect1);
      assert(!ok);
  }

  rect2 = new_rect(.{7.0, 4.0}, .{5.0, 4.0});
  {
      required_collison : Collision = .{
          .{5.0, 4.0},
          .{1.0, 0.0},
      };
      collision, ok := collides(*rect1, *rect2);
      assert(ok);
      assert(collision == required_collison);
  }

  {
      required_collison : Collision = .{
          .{4.5, 0.0},
          .{-1.0, 0.0},
      };
      collision, ok := collides(*rect2, *rect1);
      assert(ok);
      assert(collision == required_collison);
  }
}

test_scene_collision :: () {
    scene := new_scene(.{0.0, 0.0}, .{30.0, 30.0}, 1.0, .{});

    // no collison left
    {
        rect := new_rect(.{-10.0, 0.0}, .{10.0, 5.0});
        collision, ok := collides(*scene, *rect);
        assert(!ok);
    }

    // collison left
    {
        rect := new_rect(.{-10.0, 0.0}, .{11.0, 5.0});
        required_collison : Collision = .{
            .{-15.0, 0.0},
            .{1.0, 0.0},
        };
        collision, ok := collides(*scene, *rect);
        assert(ok);
        assert(collision == required_collison);
    }

    // no collison right
    {
        rect := new_rect(.{10.0, 0.0}, .{10.0, 5.0});
        collision, ok := collides(*scene, *rect);
        assert(!ok);
    }

    // collison right
    {
        rect := new_rect(.{10.0, 0.0}, .{11.0, 5.0});
        required_collison : Collision = .{
            .{15.0, 0.0},
            .{-1.0, 0.0},
        };
        collision, ok := collides(*scene, *rect);
        assert(ok);
        assert(collision == required_collison);
    }

    // no collison top
    {
        rect := new_rect(.{0.0, -10.0}, .{5.0, 10.0});
        collision, ok := collides(*scene, *rect);
        assert(!ok);
    }

    // collison top
    {
        rect := new_rect(.{0.0, -10.0}, .{5.0, 11.0});
        required_collison : Collision = {
            .{0.0, -15.0},
            .{0.0, 1.0},
        };
        collision, ok := collides(*scene, *rect);
        assert(ok);
        assert(collision == required_collison);
    }

    // no collison bot
    {
        rect := new_rect(.{0.0, 10.0}, .{5.0, 10.0});
        collision, ok := collides(*scene, *rect);
        assert(!ok);
    }

    // collison bot
    {
        rect := new_rect(.{0.0, 10.0}, .{5.0, 11.0});
        required_collison : Collision = .{
            .{0.0, 15.0},
            .{0.0, -1.0},
        };
        collision, ok := collides(*scene, *rect);
        assert(ok);
        assert(collision == required_collison);
    }
}

test_new_crate_pack:: () {
    crate_pack := new_crate_pack(
        .{0.0, 0.0},
        1,
        1,
        10.0,
        10.0,
        2.0,
        2.0,
        .{},
    );
    assert(crate_pack.crates.count == 1);

    crate_rect := new_rect(.{0.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[0].box.rect == crate_rect);
}

test_new_crate_pack_even_cols :: () {
    crate_pack := new_crate_pack(
        .{0.0, 0.0},
        1,
        2,
        10.0,
        10.0,
        2.0,
        2.0,
        .{},
    );
    assert(crate_pack.crates.count == 2);

    crate_rect := new_rect(.{-6.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[0].box.rect == crate_rect);

    crate_rect_2 := new_rect(.{6.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[1].box.rect == crate_rect_2);
}

test_new_crate_pack_odd_cols :: () {
    crate_pack := new_crate_pack(
        .{0.0, 0.0},
        1,
        3,
        10.0,
        10.0,
        2.0,
        2.0,
        .{},
    );
    assert(crate_pack.crates.count == 3);

    crate_rect := new_rect(.{-12.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[0].box.rect == crate_rect);

    crate_rect_1 := new_rect(.{0.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[1].box.rect == crate_rect_1);

    crate_rect_2 := new_rect(.{12.0, 0.0}, .{10.0, 10.0});
    assert(crate_pack.crates[2].box.rect == crate_rect_2);
}

main :: () {
  test_rect();
  test_rect_rect_collision();
  test_scene_collision();
  test_new_crate_pack();
  test_new_crate_pack_even_cols();
  test_new_crate_pack_odd_cols();
}

#import "game";
#import "Basic";
