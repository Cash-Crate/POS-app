package middleware

import (
	"context"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"

	"github.com/Cash-Crate/POS-app/server/models"
	util "github.com/Cash-Crate/POS-app/server/utilities"
	jwtutil "github.com/kittipat1413/go-common/util/jwt"
)

type ContextKey string

const UserIDKey ContextKey = "user_id"

var (
	userSessions = make(map[string]string)
	sessionLock sync.Mutex
)

func JWTAuthMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request){
		authHeader := req.Header.Get("Authorization")
		if authHeader == "" {
			util.ErrorRes(res, http.StatusUnauthorized, 
				"Authorization header not found")
			return
		}

		bearerPrefix := "Bearer "
		if !strings.HasPrefix(authHeader, bearerPrefix) {
			util.ErrorRes(res, http.StatusUnauthorized, 
				"Invalid authorization header")
		}

		tokenString := strings.TrimPrefix(authHeader, bearerPrefix) 

		signingKey := []byte(os.Getenv("SIGNING_KEY"))
		if signingKey == nil {
			log.Fatalf("Signing key not found")
			panic("Signing key not found")
		}

		manager, err := jwtutil.NewJWTManager(jwtutil.HS256, signingKey)
		if err != nil {
			log.Printf("Failed to create JWTManager: %v", err)
			util.ErrorRes(res, http.StatusInternalServerError, 
				"Authentication service unavailable")
			return
		}

		claims := &models.MyCustomClaims{}
		err = manager.ParseAndValidateToken(req.Context(), tokenString, claims)
		if err != nil {
			log.Printf("Invalid token: %v", err)
			util.ErrorRes(res, http.StatusUnauthorized, "Invalid or expired token")
			return
		}

		if claims.TokenType != "access" {
			util.ErrorRes(res, http.StatusUnauthorized, "Invalid token type")
			return
		}

		sessionLock.Lock()
		userSessions[tokenString] = strconv.Itoa(claims.UserID)
		sessionLock.Unlock()

		ctx := context.WithValue(req.Context(), UserIDKey, claims.UserID)
		next.ServeHTTP(res, req.WithContext(ctx))
	})
}

func GetUserID(ctx context.Context, token string) (string, bool) {
	userID, ok := ctx.Value(UserIDKey).(string)
	if ok {
		return userID, true
	}

	sessionLock.Lock()
	defer sessionLock.Unlock()

	userID, exists := userSessions[token]
	return userID, exists
}
