package desktop

import (
	"bufio"
	"io/fs"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"

	"windowrun/internal/config"
)

type Entry struct {
	Name     string
	Exec     string
	Terminal bool
	Keywords []string
}

var fieldCode = regexp.MustCompile(`%[a-zA-Z]`)

func Load(dirs []string, config config.Base) (entries []Entry, err error) {
	seen := map[string]bool{}

	for _, dir := range dirs {
		filepath.WalkDir(dir, func(path string, d fs.DirEntry, err error) error {
			if err != nil || d.IsDir() || !strings.HasSuffix(path, ".desktop") {
				return nil
			}

			file := filepath.Base(path)
			if slices.Contains(config.Excluded, file) || strings.HasPrefix(file, "wine") {
				return nil
			}

			entry, ok := parse(path)
			if !ok || seen[entry.Name] {
				return nil
			}

			seen[entry.Name] = true
			entry.Keywords = config.Keywords[file]
			entries = append(entries, entry)
			return nil
		})
	}

	slices.SortFunc(entries, func(a, b Entry) int {
		return strings.Compare(strings.ToLower(a.Name), strings.ToLower(b.Name))
	})

	return
}

func parse(path string) (entry Entry, ok bool) {
	file, err := os.Open(path)
	if err != nil {
		return
	}
	defer file.Close()

	var strType string
	inEntry := false

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())

		if strings.HasPrefix(line, "[") {
			if inEntry {
				break
			}
			inEntry = line == "[Desktop Entry]"
			continue
		}

		if !inEntry {
			continue
		}

		key, val, found := strings.Cut(line, "=")
		if !found {
			continue
		}
		key, val = strings.TrimSpace(key), strings.TrimSpace(val)

		switch key {
		case "Name":
			entry.Name = val
		case "Exec":
			entry.Exec = val
		case "Type":
			strType = val
		case "Terminal":
			entry.Terminal = strings.EqualFold(val, "true")
		case "NoDisplay", "Hidden":
			if val == "true" {
				return Entry{}, false
			}
		}
	}

	if entry.Name == "" || entry.Exec == "" || (strType != "" && strType != "Application") {
		return Entry{}, false
	}

	entry.Exec = strings.TrimSpace(fieldCode.ReplaceAllString(entry.Exec, ""))

	return entry, entry.Exec != ""
}
