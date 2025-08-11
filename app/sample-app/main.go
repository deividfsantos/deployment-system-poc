package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func rootHandler(w http.ResponseWriter, r *http.Request) {
	// Só responder para a rota exata "/"
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	log.Printf("Accessed root endpoint: %s %s", r.Method, r.URL.Path)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Hello World! - Sample App POC")
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Accessed health endpoint: %s %s", r.Method, r.URL.Path)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "OK")
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()

	// Registrar rotas específicas primeiro
	mux.HandleFunc("/health", healthHandler)
	mux.Handle("/metrics", promhttp.Handler())
	// Registrar a rota root por último para não interferir
	mux.HandleFunc("/", rootHandler)

	log.Printf("Server starting on port %s", port)
	log.Printf("Available endpoints:")
	log.Printf("  GET / - Root endpoint")
	log.Printf("  GET /health - Health check")
	log.Printf("  GET /metrics - Prometheus metrics")
	log.Fatal(http.ListenAndServe(":"+port, mux))
}
