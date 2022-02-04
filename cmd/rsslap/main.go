package main

import (
	"encoding/json"
	"fmt"
	"log"
	"rsslap"
)

func main() {
	flags := parseFlags()
	_ = flags
	task := rsslap.NewTask(&flags.TaskOpts, &flags.DataOpts, &flags.RecorderOpts)

	err := task.Prepare()

	if err != nil {
		log.Fatalf("Failed to prepare Task: %s", err)
	}

	rec, err := task.Run()
	_ = rec

	if err != nil {
		log.Fatalf("Failed to run Task: %s", err)
	}

	err = task.Close()

	if err != nil {
		log.Fatalf("Failed to close Task: %s", err)
	}

	if !flags.OnlyPrint {
		report := rec.Report()
		rawJson, _ := json.MarshalIndent(report, "", "  ")
		fmt.Println(string(rawJson))
	}
}
