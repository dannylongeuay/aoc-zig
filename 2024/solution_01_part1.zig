const std = @import("std");
const input = @embedFile("input_01");
// const input = @embedFile("sample_01");

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    var left = std.ArrayList(i32).init(gpa.allocator());
    defer left.deinit();
    var right = std.ArrayList(i32).init(gpa.allocator());
    defer right.deinit();
    while (it.next()) |token| {
        var split = std.mem.tokenizeScalar(u8, token, ' ');
        const l = try std.fmt.parseInt(i32, split.next().?, 10);
        const r = try std.fmt.parseInt(i32, split.next().?, 10);
        try left.append(l);
        try right.append(r);
    }
    std.mem.sort(i32, left.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, comptime std.sort.asc(i32));
    var distance: u32 = 0;
    while (left.popOrNull()) |lItem| {
        const rItem = right.pop();
        distance = distance + @abs(lItem - rItem);
    }
    std.debug.print("{d}", .{distance});
}
