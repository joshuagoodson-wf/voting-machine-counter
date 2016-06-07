package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/garyburd/redigo/redis"
	"github.com/rakyll/globalconf"
)

// Define flags
var (
	configPath            = flag.String("config", "config.yml", "Path to a configuration file")
	redisConnectionString = flag.String("redis", "redis://127.0.0.1:6379", "Redis connection string")
)

// Team defines the name (string) to vote for
type Team struct {
	Team string
}

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
		panic(fmt.Sprintf("%s: %s", msg, err))
	}
}

func main() {
	// Configure options from environment variables
	conf, err := globalconf.NewWithOptions(&globalconf.Options{
		EnvPrefix: "VOTING_",
	})
	failOnError(err, "Failed to parse options")
	conf.ParseAll()

	// Establish Redis connection
	log.Print("Connecting to Redis...")
	redisConnection, err := redis.DialURL(*redisConnectionString)
	failOnError(err, "Failed to connect to Redis")
	defer redisConnection.Close()

	// TODO: Establish messaging connection
	// TODO: Subscribe to topic for messaging

	// Create channel for consuming messages
	consume := make(chan bool)

	go func() {
		// TODO: Consume messages from the web service
		// Increment vote count for team
		// redisConnection.Do("INCR", fmt.Sprintf("%s", team.Team))
		// log.Printf("Incremented vote count for team %s", team.Team)
	}()

	log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
	<-consume
}
