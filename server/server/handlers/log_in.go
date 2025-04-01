package handlers

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
	"github.com/golang-jwt/jwt/v5"
	jwtutil "github.com/kittipat1413/go-common/util/jwt"
)

func Login(res http.ResponseWriter, req *http.Request) {
	ctx := context.Background()
	res.Header().Set("Content-Type", "application/json")

	var login models.LogIn
	err := json.NewDecoder(req.Body).Decode(&login)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not decode request body %s", err))
		return
	}

	userID, err := q.LogInQuery(login.Email, login.Password)
	if err != nil {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("Wrong email or password: %v", err))
		return
	}

	signingKey := []byte(os.Getenv("SIGNING_KEY"))
	if signingKey == nil {
		log.Fatalf("Signing key not found")
		panic("Signing key not found")
	}

	manager, err := jwtutil.NewJWTManager(jwtutil.HS256, signingKey)
	if err != nil {
		log.Fatalf("Failed to create JWTManager: %v", err)
		util.ErrorRes(res, http.StatusInternalServerError, 
		"Authentication service unavailable")
		return
	}

	accessClaims := &models.MyCustomClaims{
		UserID: userID,
		TokenType: "access",
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	accessToken, err := manager.CreateToken(ctx, accessClaims)
	if err != nil {
		log.Printf("Failed to generate access token :%v", err)
		util.ErrorRes(res, http.StatusInternalServerError, "Failed to generate authentication token")
		return
	}

	refreshClaims := &models.MyCustomClaims{
		UserID: userID,
		TokenType: "refresh",
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)), // 7 days
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	refreshToken, err := manager.CreateToken(ctx, refreshClaims)
	if err != nil {
		log.Printf("Failed to generate refresh token: %v", err)
		util.ErrorRes(res, http.StatusInternalServerError, "Failed to generate refresh token")
		return
	}

	response := models.LogInResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		UserID:       userID,
	}

	json.NewEncoder(res).Encode(response)
}

func Logout(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	authHeader := req.Header.Get("Authorization")
	if authHeader == "" {
		util.ErrorRes(res, http.StatusUnauthorized, "Authorization header required")
		return
	}

	tokenParts := strings.Split(authHeader, " ")
	if len(tokenParts) != 2 || tokenParts[0] != "Bearer" {
		util.ErrorRes(res, http.StatusUnauthorized, "Invalid authorization format")
		return
	}

	// accessToken := tokenParts[1]

	err := json.NewDecoder(req.Body).Decode(&models.LogoutReq)
	if err != nil {
		util.ErrorRes(res, http.StatusBadRequest, "Invalid request format")
		return
	}

	signingKey := []byte(os.Getenv("SIGNING_KEY"))
	if signingKey == nil {
		util.ErrorRes(res, http.StatusInternalServerError, "Signing key not found")
		log.Fatalf("Signing key not found")
		return
	}

	_, err = jwtutil.NewJWTManager(jwtutil.HS256, signingKey)
	if err != nil {
		log.Printf("Failed to create JWTManager: %v", err)
		util.ErrorRes(res, http.StatusInternalServerError,
			"Authentication service unavailable")
		return
	}

	json.NewEncoder(res).Encode(util.OkResponse{
		Message: "Successfully logged out",
	})
}

func RefreshToken(res http.ResponseWriter, req *http.Request) {
	ctx := context.Background()
	res.Header().Set("Content-Type", "application/json")

	var tokenReq struct {
		RefreshToken string `json:"refreshToken"`
	}

	err := json.NewDecoder(req.Body).Decode(&tokenReq)
	if err != nil {
		util.ErrorRes(res, http.StatusBadRequest, "Invalid request format")
		return
	}

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
	err = manager.ParseAndValidateToken(ctx, tokenReq.RefreshToken, claims)
	if err != nil {
		log.Printf("Invalid refresh token: %v", err)
		util.ErrorRes(res, http.StatusUnauthorized, "Invalid or expired refresh token")
		return
	}

	if claims.TokenType != "refresh" {
		util.ErrorRes(res, http.StatusUnauthorized, "Invalid token type")
		return
	}

	accessClaims := &models.MyCustomClaims{
		UserID: claims.UserID,
		TokenType: "access",
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	newAccessToken, err := manager.CreateToken(ctx, accessClaims)
	if err != nil {
		log.Printf("Failed to generate new access token: %v", err)
		util.ErrorRes(res, http.StatusInternalServerError, "Failed to generate new access token")
		return
	}
	
	refreshClaims := &models.MyCustomClaims{
		UserID: claims.UserID,
		TokenType: "refresh",
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	newRefreshToken, err := manager.CreateToken(ctx, refreshClaims)
	if err != nil {
		log.Printf("Failed to generate new refresh token: %v", err)
		util.ErrorRes(res, http.StatusInternalServerError, "Failed to generate new refresh token")
		return
	}

	response := models.LogInResponse{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
		UserID:       claims.UserID,
	}
	
	json.NewEncoder(res).Encode(response)
}

