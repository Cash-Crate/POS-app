package utilities

import (
	"encoding/json"
	"log"
	"net/http"
	"net/mail"
	"strings"

	db "github.com/Cash-Crate/POS-app/server/database"
)

type ErrorResponse struct {
	Error string `json:"error"`
}

type OkResponse struct {
	Message string `json:"message"`
}

func ErrorRes(res http.ResponseWriter, status int, mess string) {
	res.WriteHeader(status)
	json.NewEncoder(res).Encode(ErrorResponse{
		Error: mess,
	})
}

func IsEmailValid (email string) bool {
	if _, err := mail.ParseAddress(email); err != nil {
		return false
	}
	return true
}

func IsEmailInDB(email string, ut string) bool {
	var exists bool
	ut = strings.ToLower(ut)

	query := "SELECT EXISTS(SELECT 1 FROM users WHERE email = $1)"

	err := db.DB.QueryRow(query, email).Scan(&exists)
	if err != nil {
		log.Printf("Error checking email existence: %v", err)
		return false
	}
	return exists
}

func IsItemTypeInDB(itemType string) bool {
	var exists bool

	err := db.DB.QueryRow(`SELECT EXISTS(SELECT
		1 FROM item_types WHERE item_type_name = $1)`,
		itemType).Scan(&exists)
	if err != nil {
		log.Fatalf("Error checking if item type exists: %v", err)
		return false
	}
	return exists
}
