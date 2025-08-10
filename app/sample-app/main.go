package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	httpRequests = prometheus.NewCounterVec(
		prometheus.CounterOpts{Name: "http_requests_total"},
		[]string{"method", "path"},
	)
)

func init() {
	prometheus.MustRegister(httpRequests)
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	httpRequests.WithLabelValues(r.Method, "/").Inc()
	fmt.Fprintf(w, "Hello World! - Sample App POC")
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	httpRequests.WithLabelValues(r.Method, "/health").Inc()
	fmt.Fprintf(w, "OK")
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", helloHandler)
	http.HandleFunc("/health", healthHandler)
	http.Handle("/metrics", promhttp.Handler())

	log.Printf("Server starting on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
