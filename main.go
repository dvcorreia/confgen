package main

import (
	"fmt"
	"log/slog"
	"os"

	"sigs.k8s.io/controller-tools/pkg/markers"
)

// Provisioned by ldflags
var (
	version string
)

const (
	appName = "confgen"
)

type settings struct {
	// Debug indicates whether or not CLI is running in Debug mode.
	Debug bool
}

var defaultSettings = settings{
	Debug: false,
}

func main() {
	_ = markers.Must(markers.MakeDefinition("dummy:test", markers.DescribesType, struct{}{}))

	fmt.Printf("version: %s\n", version)
}

func warning(format string, v ...any) {
	format = fmt.Sprintf("WARNING: %s\n", format)
	fmt.Fprintf(os.Stderr, format, v...)
}

func setupLogger() {
	log := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelDebug,
	}))
	slog.SetDefault(log)
}
