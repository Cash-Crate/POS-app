package models

import (
	"github.com/golang-jwt/jwt/v5"
)

type LogIn struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LogInCred struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	UserID   int    `json:"user_id"`
}

type LogInResponse struct {
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
	UserID       int    `json:"user_id"`
}

type MyCustomClaims struct {
	jwt.RegisteredClaims
	UserID    int    `json:"user_id"`
	TokenType string `json:"token_type"`
}
