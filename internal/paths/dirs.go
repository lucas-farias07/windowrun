package paths

import (
	"errors"
	"os"
	"path/filepath"
	"slices"
	"strings"
)

var HOME, _ = os.UserHomeDir()

func DesktopDirs() (dirs []string, err error) {
	if HOME == "" {
		return nil, errors.New("could not find home directory")
	}

	strDataHome := os.Getenv("XDG_DATA_HOME")
	if strDataHome == "" {
		strDataHome = filepath.Join(HOME, ".local/share")
	}

	strDataDirs := os.Getenv("XDG_DATA_DIRS")
	if strDataDirs == "" {
		strDataDirs = "/usr/local/share:/usr/share"
	}

	paths := strings.Split(strDataHome, ":")
	paths = append(paths, strings.Split(strDataDirs, ":")...)

	for _, dir := range paths {
		if dir == "" {
			continue
		}
		path := filepath.Join(dir, "applications")

		if slices.Contains(dirs, path) {
			continue
		}

		if info, err := os.Stat(path); err == nil && info.IsDir() {
			dirs = append(dirs, path)
		}
	}

	return
}

func StateDir() (dir string, err error) {
	if HOME == "" {
		return "", errors.New("could not find home directory")
	}

	dir = os.Getenv("XDG_STATE_HOME")
	if dir == "" {
		dir = filepath.Join(HOME, ".local/state")
	}

	dir = filepath.Join(dir, "windowrun")

	return
}
