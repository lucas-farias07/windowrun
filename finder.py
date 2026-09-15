import os
import sys
import glob
import re
import json

dirs = sys.argv[1:]
seen_names = set()
results = []

CONFIG_PATH = os.path.expanduser("~/.config/windowrun/config.jsonc")


def load_config():
    try:
        raw = open(CONFIG_PATH, encoding="utf-8").read()
    except OSError:
        return {}
    raw = re.sub(r"/\*.*?\*/", "", raw, flags=re.S)
    raw = re.sub(r"^\s*//.*$", "", raw, flags=re.M)
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {}


config = load_config()
keywords = config.get("keywords", {})
EXCLUDED_FILES = set(config.get("excluded", []))

for base in dirs:
    for filepath in glob.glob(os.path.join(base, "**/*.desktop"), recursive=True):
        fname = os.path.basename(filepath)

        if fname in EXCLUDED_FILES or fname.startswith("wine"):
            continue

        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except Exception:
            continue

        entry = content.split("[Desktop Entry]")
        if len(entry) < 2:
            continue
        section = entry[1].split("\n[")[0]

        if re.search(r"^(NoDisplay|Hidden)\s*=\s*true", section, re.M):
            continue
        type_match = re.search(r"^Type\s*=\s*(.+)", section, re.M)
        if type_match and type_match.group(1).strip() != "Application":
            continue

        name_match = re.search(r"^Name\s*=\s*(.+)", section, re.M)
        exec_match = re.search(r"^Exec\s*=\s*(.+)", section, re.M)

        if not name_match or not exec_match:
            continue

        name = name_match.group(1).strip()
        exec_cmd = exec_match.group(1).strip()

        exec_cmd = re.sub(r"%[a-zA-Z]", "", exec_cmd)
        exec_cmd = re.sub(r"@@.*@@|@@", "", exec_cmd).strip()

        if name not in seen_names:
            seen_names.add(name)
            kw = keywords.get(fname, [])
            display = f"{name} ({', '.join(kw)})" if kw else name
            results.append(f"{display}\t{exec_cmd}")

results.sort(key=lambda x: x.split("\t")[0].split(" (")[0].lower())
for r in results:
    print(r)
