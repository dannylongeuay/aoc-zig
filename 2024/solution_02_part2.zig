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
        var sequence = try std.BoundedArray(i32, 1000).init(0);
        var subsequences = try std.BoundedArray(std.BoundedArray(i32, 1000), 1000).init(0);
        try findSubsequences(0, @intCast(levels.slice().len - 1), &levels, &sequence, &subsequences);
        safe += blk: {
            if (isSafe(levels.slice()) == 1) {
                break :blk 1;
            }
            for (subsequences.slice()) |seq| {
                if (isSafe(seq.slice()) == 1) {
                    break :blk 1;
                }
            }
            break :blk 0;
        };
    }
    std.debug.print("{d}\n", .{safe});
}

fn isSafe(levels: []const i32) i32 {
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

fn findSubsequences(
    curr: i32,
    seqLength: i32,
    levels: *std.BoundedArray(i32, 100),
    sequence: *std.BoundedArray(i32, 1000),
    subsequences: *std.BoundedArray(std.BoundedArray(i32, 1000), 1000),
) !void {
    if (curr == levels.len) {
        if (sequence.slice().len == seqLength) {
            try subsequences.append(sequence.*);
        }
        return;
    }
    try sequence.append(levels.slice()[@intCast(curr)]);

    try findSubsequences(curr + 1, seqLength, levels, sequence, subsequences);

    _ = sequence.pop();

    try findSubsequences(curr + 1, seqLength, levels, sequence, subsequences);
}
