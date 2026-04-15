// See https://docs.arduino.cc/arduino-cli/platform-specification/#1200-bps-bootloader-reset

package main

import (
	"flag"
	"fmt"
	"os"
	serialutils "github.com/arduino/go-serial-utils"
)

func main() {
	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "Usage: %s <usb-port>\n", os.Args[0])
		flag.PrintDefaults()
	}

	flag.Parse()
	if flag.NArg() < 1 {
		flag.Usage()
	}
	var newPort string
	var err error
	if  newPort, err = serialutils.Reset(flag.Arg(0), false, false, nil, nil); err != nil {
		fmt.Fprintf(os.Stderr, "touch1200bps: %s\n", err)
		os.Exit(1)
	}
	fmt.Fprintf(os.Stdout, newPort)
}
