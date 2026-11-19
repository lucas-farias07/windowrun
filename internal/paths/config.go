package paths

import (
	"errors"
	"os"
	"path/filepath"
)

func ConfigDir() (dir string, err error) {
	if HOME == "" {
		return "", errors.New("could not find home directory")
	}

	dir = os.Getenv("XDG_CONFIG_HOME")
	if !filepath.IsAbs(dir) {
		dir = filepath.Join(HOME, ".config")
	}

	dir = filepath.Join(dir, "windowrun")

	return
}
