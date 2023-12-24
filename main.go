package main

import (
	"log"
	"net/http"
	"time"
)

func main() {
	// Create file server handler
	fs := http.FileServer(http.Dir("static"))

	// Wrap the file server handler with the logRequest middleware
	http.Handle("/", logRequest(fs))

	// Start the server on port 8080
	log.Println("Listening on :8080...")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}

// logRequest is a middleware that logs HTTP requests
func logRequest(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Get the client IP address
		clientIP := r.RemoteAddr

		// Log the start of the request
		start := time.Now()
		log.Printf("Started %s %s from %s", r.Method, r.URL.Path, clientIP)

		// Call the next handler
		next.ServeHTTP(w, r)

		// Log the response time
		log.Printf("Completed %s in %v", r.URL.Path, time.Since(start))
	})
}
