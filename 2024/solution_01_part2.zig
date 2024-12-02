const std = @import("std");
const input = @embedFile("input_01");
// const input = @embedFile("sample_01");

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    var left = std.ArrayList(i32).init(gpa.allocator());
    defer left.deinit();
    var right = std.AutoHashMap(i32, i32).init(gpa.allocator());
    defer right.deinit();
    while (it.next()) |token| {
        var split = std.mem.tokenizeScalar(u8, token, ' ');
        const l = try std.fmt.parseInt(i32, split.next().?, 10);
        const r = try std.fmt.parseInt(i32, split.next().?, 10);
        try left.append(l);
        if (right.contains(r)) {
            try right.put(r, right.get(r).? + 1);
        } else {
            try right.put(r, 1);
        }
    }
    var similarities: i32 = 0;
    while (left.popOrNull()) |lItem| {
        if (!right.contains(lItem)) {
            continue;
        }
        similarities = similarities + lItem * right.get(lItem).?;
    }
    std.debug.print("{d}", .{similarities});
}
