package server

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/Cash-Crate/POS-app/server/handlers"
	"github.com/Cash-Crate/POS-app/server/middleware"
	"github.com/Cash-Crate/POS-app/server/models"
	util "github.com/Cash-Crate/POS-app/server/utilities"
	jwtutil "github.com/kittipat1413/go-common/util/jwt"
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

	signingKey := []byte(os.Getenv("SIGNING_KEY"))
	if len(signingKey) == 0 {
		log.Fatalf("Warning: SIGNING_KEY not set or empty")
		panic("Warning: SIGNING_KEY not set or empty")
	}

	corsHandler := cors.New(corsOpts).Handler(mux)
	fmt.Printf("Listening at port %s\n", PORT)

	mux.HandleFunc("/", handlers.GetRoot)
	mux.HandleFunc("POST /api/login", handlers.Login)
	mux.HandleFunc("POST /api/refresh", handlers.RefreshToken)

	jwtProtected := func(handler http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				util.ErrorRes(w, http.StatusUnauthorized, "Authorization header required")
				return
			}

			bearerPrefix := "Bearer "
			if !strings.HasPrefix(authHeader, bearerPrefix) {
				util.ErrorRes(w, http.StatusUnauthorized, "Invalid authorization format")
				return
			}
			tokenString := strings.TrimPrefix(authHeader, bearerPrefix)

			manager, err := jwtutil.NewJWTManager(jwtutil.HS256, signingKey)
			if err != nil {
				log.Printf("Failed to create JWTManager: %v", err)
				util.ErrorRes(w, http.StatusInternalServerError, "Authentication service unavailable")
				return
			}

			claims := &models.MyCustomClaims{}
			err = manager.ParseAndValidateToken(r.Context(), tokenString, claims)

			if err != nil {
				log.Printf("Invalid token: %v", err)
				util.ErrorRes(w, http.StatusUnauthorized, "Invalid or expired token")
				return
			}

			if claims.TokenType != "access" {
				util.ErrorRes(w, http.StatusUnauthorized, "Invalid token type")
				return
			}

			ctx := context.WithValue(r.Context(), middleware.UserIDKey, claims.UserID)
			handler(w, r.WithContext(ctx))
		}
	}

	mux.HandleFunc("POST /api/logins/create", jwtProtected(handlers.PostLogin))
	mux.HandleFunc("GET /api/users", jwtProtected(handlers.GetUsers))
	mux.HandleFunc("GET /api/users/", jwtProtected(handlers.GetUserByID))
	mux.HandleFunc("POST /api/users/create", jwtProtected(handlers.CreateUser))
	mux.HandleFunc("DELETE /api/users/", jwtProtected(handlers.DeleteUser))
	mux.HandleFunc("GET /api/logins", jwtProtected(handlers.GetLogins))
	mux.HandleFunc("GET /api/itemtypes", jwtProtected(handlers.GetItemTypes))
	mux.HandleFunc("POST /api/itemtypes/create", jwtProtected(handlers.CreateItemType))
	// mux.HandleFunc("DELETE /api/itemtypes", jwtProtected(handlers.DeleteItemTypes))
	mux.HandleFunc("GET /api/items", jwtProtected(handlers.GetItems))
	mux.HandleFunc("GET /api/items/{id}", jwtProtected(handlers.GetItemByID))
	mux.HandleFunc("POST /api/items/create", jwtProtected(handlers.CreateItem))
	mux.HandleFunc("PUT /api/items/{id}", jwtProtected(handlers.UpdateItem))
	mux.HandleFunc("PUT /api/items/{id}/{quantity}", jwtProtected(handlers.SellItem))
	mux.HandleFunc("DELETE /api/items/{id}", jwtProtected(handlers.DeleteItem))
	mux.HandleFunc("GET /api/items/attrs/{id}", jwtProtected(handlers.GetItemAttrs))
	mux.HandleFunc("POST /api/items/attrs/create/{id}", jwtProtected(handlers.CreateItemAttrs))
	mux.HandleFunc("PUT /api/items/attrs/{id}/{name}", jwtProtected(handlers.UpdateItemAttr))
	mux.HandleFunc("GET /api/crud", jwtProtected(handlers.GetCrudActions))

	if err := http.ListenAndServe(PORT, corsHandler); err != nil {
		log.Fatal(err)
	}
}
