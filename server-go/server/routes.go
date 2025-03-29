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
	mux.HandleFunc("GET /api/users", handlers.GetUsers)
	mux.HandleFunc("GET /api/users/", handlers.GetUserByID)
	mux.HandleFunc("POST /api/users/create", handlers.CreateUser)
	mux.HandleFunc("DELETE /api/users/", handlers.DeleteUser)

	if err := http.ListenAndServe(PORT, handler); err != nil {
		log.Fatal(err)
	}
}
