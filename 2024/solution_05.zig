const std = @import("std");
const input = @embedFile("input_05");
// const input = @embedFile("sample_05");

const Rule = struct { x: usize, y: usize };

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var input_it = std.mem.tokenizeSequence(u8, input, "\n\n");
    const first = input_it.next().?;
    const last = input_it.next().?;
    std.debug.assert(input_it.next() == null);

    var first_it = std.mem.tokenizeScalar(u8, first, '\n');
    var page_rules = std.AutoHashMap(Rule, bool).init(allocator);
    while (first_it.next()) |line| {
        var split = std.mem.tokenizeScalar(u8, line, '|');
        const x = try std.fmt.parseInt(usize, split.next().?, 10);
        const y = try std.fmt.parseInt(usize, split.next().?, 10);
        try page_rules.put(Rule{ .x = x, .y = y }, true);
        try page_rules.put(Rule{ .x = y, .y = x }, false);
    }

    var p1: usize = 0;
    var p2: usize = 0;

    var last_it = std.mem.tokenizeScalar(u8, last, '\n');
    while (last_it.next()) |line| {
        var split = std.mem.tokenizeScalar(u8, line, ',');
        var page_update = std.ArrayList(usize).init(allocator);
        while (split.next()) |page| {
            try page_update.append(try std.fmt.parseInt(usize, page, 10));
        }
        const isSorted = std.sort.isSorted(usize, page_update.items, &page_rules, byRules);
        if (isSorted) {
            p1 += page_update.items[page_update.items.len / 2];
            continue;
        }
        std.mem.sort(usize, page_update.items, &page_rules, byRules);
        p2 += page_update.items[page_update.items.len / 2];
    }

    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}

fn byRules(context: *std.AutoHashMap(Rule, bool), left: usize, right: usize) bool {
    const r = Rule{ .x = left, .y = right };
    return context.*.contains(r) and context.*.get(r).? == true;
}
