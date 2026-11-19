package run

import (
	"os"
	"os/exec"
	"syscall"
)

func SpawnWindowrun() {
	cmd := exec.Command(os.Getenv("TERMINAL"))
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}
	cmd.Start()
}
