const std = @import("std");
const stdin = std.io.getStdIn().reader();

const MAX_SIZE = 1024 * 1024;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try stdin.readAllAlloc(allocator, MAX_SIZE);
    var input_it = std.mem.tokenizeScalar(u8, input, '\n');

    var p1: isize = 0;
    var p2: isize = 0;
    while (input_it.next()) |line| {
        var line_split = std.mem.tokenizeScalar(u8, line, ':');
        const target = try std.fmt.parseInt(isize, line_split.next().?, 10);
        var words_it = std.mem.tokenizeScalar(u8, std.mem.trim(u8, line_split.next().?, " "), ' ');
        var nums = std.ArrayList(isize).init(allocator);
        while (words_it.next()) |word| {
            try nums.append(try std.fmt.parseInt(isize, word, 10));
        }
        if (try canSolve(
            &allocator,
            target,
            nums.items,
            false,
        )) {
            p1 += target;
        }
        if (try canSolve(
            &allocator,
            target,
            nums.items,
            true,
        )) {
            p2 += target;
        }
    }

    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}

fn canSolve(
    allocator: *const std.mem.Allocator,
    target: isize,
    nums: []isize,
    with_concat: bool,
) !bool {
    if (nums.len == 1) {
        return target == nums[0];
    }

    const lastIdx = nums.len - 1;
    const last = nums[lastIdx];

    if (@mod(target, last) == 0 and
        try canSolve(
        allocator,
        @divExact(target, last),
        nums[0..lastIdx],
        with_concat,
    )) {
        return true;
    }

    if (target > last and
        try canSolve(
        allocator,
        target - last,
        nums[0..lastIdx],
        with_concat,
    )) {
        return true;
    }

    if (with_concat) {
        const targetStr = try std.fmt.allocPrint(allocator.*, "{d}", .{target});
        const lastStr = try std.fmt.allocPrint(allocator.*, "{d}", .{last});
        return targetStr.len > lastStr.len and
            std.mem.endsWith(u8, targetStr, lastStr) and
            try canSolve(
            allocator,
            try std.fmt.parseInt(isize, targetStr[0 .. targetStr.len - lastStr.len], 10),
            nums[0..lastIdx],
            with_concat,
        );
    }

    return false;
}
