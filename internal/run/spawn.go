package run

import (
	"errors"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"syscall"

	"windowrun/internal/config"
	"windowrun/internal/desktop"
	"windowrun/internal/paths"
	"windowrun/internal/ui"
)

func Start() error {
	configDir, err := paths.ConfigDir()
	if err != nil {
		return err
	}

	cfg, err := config.Config(filepath.Join(configDir, "config.jsonc"))
	if errors.Is(err, fs.ErrNotExist) {
		cfg, err = &config.Settings{}, nil // no config file is fine
	}
	if err != nil {
		return err
	}

	dirs, err := paths.DesktopDirs()
	if err != nil {
		return err
	}

	entries, err := desktop.Load(dirs, cfg.Base)
	if err != nil {
		return err
	}

	choice, err := ui.App(entries)
	if err != nil {
		return err
	}
	if choice == nil { // user cancelled
		return nil
	}

	return Spawn(*choice)
}

// Spawn launches the entry detached from windowrun (own session, no stdio).
func Spawn(e desktop.Entry) error {
	var cmd *exec.Cmd

	if e.Terminal {
		term := os.Getenv("TERMINAL")
		if term == "" {
			return errors.New("$TERMINAL is not set")
		}
		cmd = exec.Command(term, "sh", "-c", e.Exec)
	} else {
		cmd = exec.Command("sh", "-c", e.Exec)
	}

	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}

	if err := cmd.Start(); err != nil {
		return err
	}
	return cmd.Process.Release()
}
