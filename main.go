package main

import (
	"fmt"
	"os"

	"windowrun/internal/run"
)

func main() {
	if err := run.Start(); err != nil {
		fmt.Fprintln(os.Stderr, "windowrun:", err)
		os.Exit(1)
	}
}
