const std = @import("std");
const input = @embedFile("input_03");
// const input = @embedFile("sample_03");

pub fn main() !void {
    var s = input;
    var p1: i32 = 0;
    var p2: i32 = 0;
    var i: usize = 0;
    var enable = true;
    while (i < s.len) {
        defer i += 1;

        if (i + 7 > s.len) {
            break;
        }

        if (std.mem.eql(u8, "do()", s[i .. i + 4])) {
            enable = true;
            i += 3;
            continue;
        }

        if (std.mem.eql(u8, "don't()", s[i .. i + 7])) {
            enable = false;
            i += 6;
            continue;
        }

        if (!std.mem.eql(u8, "mul(", s[i .. i + 4])) {
            continue;
        }

        i += 4;
        var d1: i32 = undefined;
        var ok = try parseDigits(&i, s, &d1);
        if (!ok or s[i] != ',') {
            continue;
        }

        i += 1;
        var d2: i32 = undefined;
        ok = try parseDigits(&i, s, &d2);
        if (!ok or s[i] != ')') {
            continue;
        }

        p1 += d1 * d2;
        if (enable) {
            p2 += d1 * d2;
        }
    }
    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}

fn parseDigits(i: *usize, s: []const u8, d1: *i32) !bool {
    var j: usize = 0;
    while (std.ascii.isDigit(s[i.* + j])) {
        j += 1;
    }
    if (j < 1 or j > 3) {
        return false;
    }
    d1.* = try std.fmt.parseInt(i32, s[i.* .. i.* + j], 10);
    i.* += j;
    return true;
}
