const std = @import("std");
const input = @embedFile("input_02");
// const input = @embedFile("sample_02");

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var safe: i32 = 0;
    while (it.next()) |token| {
        var split = std.mem.tokenizeScalar(u8, token, ' ');
        var levels = try std.BoundedArray(i32, 100).init(0);
        while (split.next()) |level| {
            try levels.append(try std.fmt.parseInt(i32, level, 10));
        }
        safe += isSafe(levels.slice());
    }
    std.debug.print("{d}\n", .{safe});
}

fn isSafe(levels: []i32) i32 {
    if (levels[0] == levels[1]) {
        return 0;
    }
    if (levels[0] < levels[1]) {
        for (0..levels.len - 1) |i| {
            if (levels[i] >= levels[i + 1]) {
                return 0;
            }
            if (@abs(levels[i] - levels[i + 1]) > 3) {
                return 0;
            }
        }
    } else {
        for (0..levels.len - 1) |i| {
            if (levels[i] <= levels[i + 1]) {
                return 0;
            }
            if (@abs(levels[i] - levels[i + 1]) > 3) {
                return 0;
            }
        }
    }
    return 1;
}
