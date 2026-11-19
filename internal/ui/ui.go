package ui

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"

	"windowrun/internal/desktop"
)

func App(entries []desktop.Entry) (*desktop.Entry, error) {
	var in, out bytes.Buffer

	for i, e := range entries {
		name := e.Name
		if len(e.Keywords) > 0 {
			name += " (" + strings.Join(e.Keywords, ", ") + ")"
		}
		fmt.Fprintf(&in, "%s\t%d\n", name, i)
	}

	cmd := exec.Command("fzf", "--prompt=~ ", "--delimiter=\t", "--with-nth=1")
	cmd.Stdin, cmd.Stdout, cmd.Stderr = &in, &out, os.Stderr

	if err := cmd.Run(); err != nil {
		var exitErr *exec.ExitError
		if errors.As(err, &exitErr) && (exitErr.ExitCode() == 1 || exitErr.ExitCode() == 130) {
			return nil, nil
		}
		return nil, err
	}

	_, strIdx, _ := strings.Cut(strings.TrimSpace(out.String()), "\t")
	idx, err := strconv.Atoi(strIdx)
	if err != nil || idx < 0 || idx >= len(entries) {
		return nil, errors.New("unexpected fzf output")
	}

	return &entries[idx], nil
}
