const std = @import("std");
const stdin = std.io.getStdIn().reader();

const MAX_SIZE = 1024 * 1024;

const Point = struct { x: isize, y: isize };
const PointDir = struct { x: isize, y: isize, d: usize };

const guardDirs = [4]Point{
    Point{ .x = 0, .y = -1 },
    Point{ .x = 1, .y = 0 },
    Point{ .x = 0, .y = 1 },
    Point{ .x = -1, .y = 0 },
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try stdin.readAllAlloc(allocator, MAX_SIZE);
    var grid = std.AutoHashMap(Point, u8).init(allocator);

    var input_it = std.mem.tokenizeScalar(u8, input, '\n');
    var row: isize = 0;
    var startingPoint: Point = undefined;
    while (input_it.next()) |line| {
        for (0..line.len) |col| {
            if (line[col] == '^') {
                startingPoint = Point{ .x = @intCast(col), .y = row };
            }
            try grid.put(Point{ .x = @intCast(col), .y = row }, line[col]);
        }
        row += 1;
    }

    var visited = std.AutoHashMap(Point, void).init(allocator);
    defer visited.deinit();
    _ = try runSim(&grid, startingPoint, &visited, &allocator);

    const p1: usize = visited.count();
    var p2: usize = 0;

    var visited_points_it = visited.keyIterator();

    while (visited_points_it.next()) |p| {
        if (p.*.x == startingPoint.x and p.*.y == startingPoint.y) {
            continue;
        }
        try grid.put(p.*, '#');
        var visitedLoop = std.AutoHashMap(Point, void).init(allocator);
        defer visitedLoop.deinit();
        const is_cycle = try runSim(&grid, startingPoint, &visitedLoop, &allocator);
        if (is_cycle) {
            p2 += 1;
        }
        try grid.put(p.*, '.');
    }

    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}

fn runSim(
    grid: *std.AutoHashMap(Point, u8),
    startingPoint: Point,
    visited: *std.AutoHashMap(Point, void),
    allocator: *const std.mem.Allocator,
) !bool {
    var currentPoint: Point = Point{ .x = startingPoint.x, .y = startingPoint.y };
    var currentDirIndex: usize = 0;
    var visitedWithDir = std.AutoHashMap(PointDir, void).init(allocator.*);
    while (grid.get(currentPoint) != null) {
        try visited.put(currentPoint, {});

        const currentPointWithDir = PointDir{ .x = currentPoint.x, .y = currentPoint.y, .d = currentDirIndex };
        const visDir = try visitedWithDir.fetchPut(currentPointWithDir, {});
        if (visDir != null) {
            return true;
        }

        var currentDir = guardDirs[currentDirIndex];
        var nextPoint = Point{
            .x = currentPoint.x + currentDir.x,
            .y = currentPoint.y + currentDir.y,
        };
        while (grid.get(nextPoint)) |nextObstacle| {
            if (nextObstacle != '#') {
                break;
            }
            currentDirIndex = (currentDirIndex + 1) % guardDirs.len;
            currentDir = guardDirs[currentDirIndex];
            nextPoint = Point{
                .x = currentPoint.x + currentDir.x,
                .y = currentPoint.y + currentDir.y,
            };
        }
        currentPoint = Point{
            .x = currentPoint.x + currentDir.x,
            .y = currentPoint.y + currentDir.y,
        };
    }
    return false;
}
