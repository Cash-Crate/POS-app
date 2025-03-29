package server

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Cash-Crate/POS-app/server/handlers"
	"github.com/rs/cors"
)

var PORT = ":3000"

func ServeHttp() {
	mux := http.NewServeMux()
	corsOpts := cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Authorization", "Content-Type"},
		AllowCredentials: true,
	}

	handler := cors.New(corsOpts).Handler(mux)
	fmt.Printf("Listening at port %s\n", PORT)

	mux.HandleFunc("/", handlers.GetRoot)
	mux.HandleFunc("/api/users/", handlers.GetUsers)

	if err := http.ListenAndServe(PORT, handler); err != nil {
		log.Fatal(err)
	}
}
