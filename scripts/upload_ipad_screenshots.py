#!/usr/bin/env python3
"""Upload iPad 13" screenshots to ASC for the rejected version.

Usage: python3 scripts/upload_ipad_screenshots.py path1.png path2.png ...
"""
import os, sys, json, hashlib
from pathlib import Path
import urllib.request, urllib.error
import subprocess

SET_ID = "0b0d7e4d-64a0-4abb-813e-03e567dfdaed"
TOKEN = subprocess.check_output(["python3", os.path.expanduser("~/.claude/scripts/asc_token.py")]).decode().strip()
HDR = {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"}

def req(method, path, body=None):
    url = path if path.startswith("http") else f"https://api.appstoreconnect.apple.com{path}"
    data = json.dumps(body).encode() if body else None
    r = urllib.request.Request(url, data=data, method=method, headers=HDR)
    try:
        with urllib.request.urlopen(r) as resp:
            text = resp.read().decode()
            return json.loads(text) if text else {}
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"HTTP {e.code}: {body[:400]}", file=sys.stderr)
        raise

def reserve(filename, file_size):
    body = {
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": filename, "fileSize": file_size},
            "relationships": {
                "appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": SET_ID}}
            },
        }
    }
    return req("POST", "/v1/appScreenshots", body)["data"]

def upload_chunks(operations, file_path):
    with open(file_path, "rb") as f:
        for op in operations:
            offset = op["offset"]; length = op["length"]
            url = op["url"]
            method = op.get("method", "PUT").upper()
            f.seek(offset)
            chunk = f.read(length)
            r = urllib.request.Request(url, data=chunk, method=method)
            for h in op.get("requestHeaders", []):
                r.add_header(h["name"], h["value"])
            with urllib.request.urlopen(r) as resp:
                resp.read()

def commit(screenshot_id, file_path):
    md5 = hashlib.md5(open(file_path, "rb").read()).hexdigest()
    body = {
        "data": {
            "type": "appScreenshots",
            "id": screenshot_id,
            "attributes": {"uploaded": True, "sourceFileChecksum": md5},
        }
    }
    return req("PATCH", f"/v1/appScreenshots/{screenshot_id}", body)

def main():
    files = sys.argv[1:]
    if not files:
        print("Usage: upload_ipad_screenshots.py file1.png file2.png ...", file=sys.stderr)
        sys.exit(1)
    for i, fp in enumerate(files, 1):
        path = Path(fp).expanduser()
        size = path.stat().st_size
        print(f"\n[{i}/{len(files)}] {path.name} ({size:,} bytes)")
        reserved = reserve(path.name, size)
        sid = reserved["id"]
        ops = reserved["attributes"]["uploadOperations"]
        print(f"  reserved id={sid}, {len(ops)} chunk(s)")
        upload_chunks(ops, path)
        print(f"  chunks uploaded")
        commit(sid, path)
        print(f"  ✓ committed")

if __name__ == "__main__":
    main()
