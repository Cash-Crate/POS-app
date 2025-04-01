package server

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Cash-Crate/POS-app/server/handlers"
	m "github.com/Cash-Crate/POS-app/server/middleware"
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

	corsHandler := cors.New(corsOpts).Handler(mux)
	fmt.Printf("Listening at port %s\n", PORT)

	mux.HandleFunc("/", handlers.GetRoot)
	mux.HandleFunc("POST /api/login", handlers.Login)
	mux.HandleFunc("POST /api/refresh", handlers.RefreshToken)

	mux.HandleFunc("POST /api/logins/create", m.JWTAuthMiddleware(handlers.PostLogin))
	mux.HandleFunc("PUT /api/logins/{id}", m.JWTAuthMiddleware(handlers.PutLogin))
	mux.HandleFunc("GET /api/users", m.JWTAuthMiddleware(handlers.GetUsers))
	mux.HandleFunc("GET /api/users/", m.JWTAuthMiddleware(handlers.GetUserByID))
	mux.HandleFunc("POST /api/users/create", m.JWTAuthMiddleware(handlers.CreateUser))
	mux.HandleFunc("DELETE /api/users/", m.JWTAuthMiddleware(handlers.DeleteUser))
	mux.HandleFunc("GET /api/logins", m.JWTAuthMiddleware(handlers.GetLogins))
	mux.HandleFunc("GET /api/itemtypes", m.JWTAuthMiddleware(handlers.GetItemTypes))
	mux.HandleFunc("POST /api/itemtypes/create", m.JWTAuthMiddleware(handlers.CreateItemType))
	// mux.HandleFunc("DELETE /api/itemtypes", m.JWTAuthMiddleware(handlers.DeleteItemTypes))
	mux.HandleFunc("GET /api/items", m.JWTAuthMiddleware(handlers.GetItems))
	mux.HandleFunc("GET /api/items/{id}", m.JWTAuthMiddleware(handlers.GetItemByID))
	mux.HandleFunc("POST /api/items/create", m.ItemLogger(m.JWTAuthMiddleware(handlers.CreateItem)))
	mux.HandleFunc("PUT /api/items/{id}", m.ItemLogger(m.JWTAuthMiddleware(handlers.UpdateItem)))
	mux.HandleFunc("PUT /api/items/{id}/{quantity}", m.ItemLogger(m.JWTAuthMiddleware(handlers.SellItem)))
	mux.HandleFunc("DELETE /api/items/{id}", m.ItemLogger(m.JWTAuthMiddleware(handlers.DeleteItem)))
	mux.HandleFunc("GET /api/items/attrs/{id}", m.ItemLogger(m.JWTAuthMiddleware(handlers.GetItemAttrs)))
	mux.HandleFunc("POST /api/items/attrs/create/{id}", m.ItemLogger(m.JWTAuthMiddleware(handlers.CreateItemAttrs)))
	mux.HandleFunc("PUT /api/items/attrs/{id}/{name}", m.ItemLogger(m.JWTAuthMiddleware(handlers.UpdateItemAttr)))
	mux.HandleFunc("GET /api/crud", m.JWTAuthMiddleware(handlers.GetCrudActions))

	if err := http.ListenAndServe(PORT, corsHandler); err != nil {
		log.Fatal(err)
	}
}
