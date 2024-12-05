const std = @import("std");
const input = @embedFile("input_04");
// const input = @embedFile("sample_04");

const ARRAY_CAPACITY = 200;

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var p1: i32 = 0;
    var p2: i32 = 0;
    var grid = try std.BoundedArray(std.BoundedArray(u8, ARRAY_CAPACITY), ARRAY_CAPACITY).init(0);
    while (it.next()) |line| {
        try grid.append(try std.BoundedArray(u8, ARRAY_CAPACITY).fromSlice(line));
    }

    for (0..grid.slice().len) |x| {
        for (0..grid.slice()[x].slice().len) |y| {
            searchXmas(x, y, &grid, &p1);
            searchMas(x, y, &grid, &p2);
        }
    }

    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}
fn searchMas(
    x: usize,
    y: usize,
    grid: *std.BoundedArray(std.BoundedArray(u8, ARRAY_CAPACITY), ARRAY_CAPACITY),
    matches: *i32,
) void {
    if (x >= 1 and y >= 1 and x < grid.slice().len - 1 and y < grid.slice()[x].slice().len - 1) {
        if (grid.slice()[x - 1].slice()[y - 1] == 'M' and
            grid.slice()[x].slice()[y] == 'A' and
            grid.slice()[x + 1].slice()[y + 1] == 'S' and
            grid.slice()[x + 1].slice()[y - 1] == 'M' and
            grid.slice()[x - 1].slice()[y + 1] == 'S')
        {
            matches.* += 1;
        }
        if (grid.slice()[x - 1].slice()[y - 1] == 'M' and
            grid.slice()[x].slice()[y] == 'A' and
            grid.slice()[x + 1].slice()[y + 1] == 'S' and
            grid.slice()[x + 1].slice()[y - 1] == 'S' and
            grid.slice()[x - 1].slice()[y + 1] == 'M')
        {
            matches.* += 1;
        }
        if (grid.slice()[x - 1].slice()[y - 1] == 'S' and
            grid.slice()[x].slice()[y] == 'A' and
            grid.slice()[x + 1].slice()[y + 1] == 'M' and
            grid.slice()[x + 1].slice()[y - 1] == 'M' and
            grid.slice()[x - 1].slice()[y + 1] == 'S')
        {
            matches.* += 1;
        }
        if (grid.slice()[x - 1].slice()[y - 1] == 'S' and
            grid.slice()[x].slice()[y] == 'A' and
            grid.slice()[x + 1].slice()[y + 1] == 'M' and
            grid.slice()[x + 1].slice()[y - 1] == 'S' and
            grid.slice()[x - 1].slice()[y + 1] == 'M')
        {
            matches.* += 1;
        }
    }
}

fn searchXmas(
    x: usize,
    y: usize,
    grid: *std.BoundedArray(std.BoundedArray(u8, ARRAY_CAPACITY), ARRAY_CAPACITY),
    matches: *i32,
) void {
    // horizontal search
    if (y < grid.slice()[x].slice().len - 3) {
        if (std.mem.eql(u8, "XMAS", grid.slice()[x].slice()[y .. y + 4])) {
            matches.* += 1;
        }
        if (std.mem.eql(u8, "SAMX", grid.slice()[x].slice()[y .. y + 4])) {
            matches.* += 1;
        }
    }
    // vertical search
    if (x < grid.slice().len - 3) {
        if (grid.slice()[x].slice()[y] == 'X' and
            grid.slice()[x + 1].slice()[y] == 'M' and
            grid.slice()[x + 2].slice()[y] == 'A' and
            grid.slice()[x + 3].slice()[y] == 'S')
        {
            matches.* += 1;
        }
        if (grid.slice()[x].slice()[y] == 'S' and
            grid.slice()[x + 1].slice()[y] == 'A' and
            grid.slice()[x + 2].slice()[y] == 'M' and
            grid.slice()[x + 3].slice()[y] == 'X')
        {
            matches.* += 1;
        }
    }
    // positive diag
    if (x >= 3 and y < grid.slice()[x].slice().len - 3) {
        if (grid.slice()[x].slice()[y] == 'X' and
            grid.slice()[x - 1].slice()[y + 1] == 'M' and
            grid.slice()[x - 2].slice()[y + 2] == 'A' and
            grid.slice()[x - 3].slice()[y + 3] == 'S')
        {
            matches.* += 1;
        }
        if (grid.slice()[x].slice()[y] == 'S' and
            grid.slice()[x - 1].slice()[y + 1] == 'A' and
            grid.slice()[x - 2].slice()[y + 2] == 'M' and
            grid.slice()[x - 3].slice()[y + 3] == 'X')
        {
            matches.* += 1;
        }
    }
    // negative diag
    if (x >= 3 and y >= 3) {
        if (grid.slice()[x].slice()[y] == 'X' and
            grid.slice()[x - 1].slice()[y - 1] == 'M' and
            grid.slice()[x - 2].slice()[y - 2] == 'A' and
            grid.slice()[x - 3].slice()[y - 3] == 'S')
        {
            matches.* += 1;
        }
        if (grid.slice()[x].slice()[y] == 'S' and
            grid.slice()[x - 1].slice()[y - 1] == 'A' and
            grid.slice()[x - 2].slice()[y - 2] == 'M' and
            grid.slice()[x - 3].slice()[y - 3] == 'X')
        {
            matches.* += 1;
        }
    }
}
