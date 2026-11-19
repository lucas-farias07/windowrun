package run

import (
	"os"
	"os/exec"
	"syscall"
)

func SpawnWindowrun() error {
	cmd := exec.Command(os.Getenv("TERMINAL"))
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}
	err := cmd.Start()
	if err != nil {
		return err
	}
	return nil
}
