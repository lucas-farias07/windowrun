package config

import (
	"encoding/json"
	"os"

	"github.com/tailscale/hujson"
)

type Base struct {
	Keywords map[string][]string `json:"keywords"`
	Excluded []string            `json:"excluded"`
}

type Settings struct {
	Base       Base              `json:"base"`
	Extensions []json.RawMessage `json:"extensions"`
}

func Config(path string) (*Settings, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}

	std, err := hujson.Standardize(data)
	if err != nil {
		return nil, err
	}

	var s Settings
	if err := json.Unmarshal(std, &s); err != nil {
		return nil, err
	}
	return &s, nil
}
