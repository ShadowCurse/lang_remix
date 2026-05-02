const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "fizzbuzz",
        .root_module = root_module,
    });
    const install_step = b.addInstallArtifact(exe, .{});

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |a| run_cmd.addArgs(a);
    run_cmd.step.dependOn(&install_step.step);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
