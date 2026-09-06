#!/usr/bin/env python3
"""Fails if app code reads a launch hook outside CaptureHooks.

Fleet round 131. Six FF_ hooks were being read straight from ProcessInfo in shipping code,
and a Release build launched with FF_INITIAL_TAB=play FF_PUSH_SPARRING=1 opened a live
sparring session before the player touched anything.

`strings` is not the test. Swift stores literals of 15 UTF-8 bytes or fewer inline in
immediates, so of the sixteen hook names only FF_PUSH_SPARRING was long enough for `strings`
to find whole; the others showed as fragments like FF_PUSH_H or not at all. A search for the
full names would have reported the binary clean while five hooks were still live in it. So
this lints the source, and the round proved the fix by launching the Release build with the
variables set and watching where it landed.
"""
import re, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent / "FrameFork"
HOME = "FrameForkApp.swift"          # where CaptureHooks itself lives
bad = []

for path in sorted(ROOT.rglob("*.swift")):
    if path.name == HOME:
        continue
    stack = []
    for lineno, line in enumerate(path.read_text().split("\n"), 1):
        s = line.strip()
        if s.startswith("#if"):
            stack.append("DEBUG" in s)
        elif s.startswith("#elseif"):
            if stack: stack[-1] = False
        elif s.startswith("#else"):
            if stack: stack[-1] = not stack[-1]
        elif s.startswith("#endif"):
            if stack: stack.pop()
        m = re.search(r'environment\["([A-Z_]+)"\]', line)
        if m and not any(stack):
            bad.append(f"{path.relative_to(ROOT.parent)}:{lineno}  {m.group(1)}")

if bad:
    print("REFUSED: launch hooks read outside CaptureHooks and outside #if DEBUG:")
    for b in bad:
        print("  " + b)
    print("\nRoute the read through CaptureHooks.value(_:) or CaptureHooks.isOn(_:), which")
    print("returns nil in a Release build.")
    sys.exit(1)

print("capture hooks: 0 unguarded environment reads in app code")
