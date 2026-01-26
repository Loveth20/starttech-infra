package main

import (
    "log"
    "net/http"
    "github.com/gorilla/mux"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
}

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/health", healthHandler)

    log.Println("Backend running on port 8080")
    err := http.ListenAndServe(":8080", r)
    if err != nil {
        log.Fatal(err)
    }
}

