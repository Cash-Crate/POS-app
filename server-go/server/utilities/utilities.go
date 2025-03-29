package utilities

import (
	"database/sql"
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
	var rows *sql.Rows
	var err error

	ut = strings.ToLower(ut)

	switch ut {
	case "admin":
		rows, err = db.DB.Query(`SELECT
			email
			FROM users
			WHERE email = $1`, email)
	case "staff":
		rows, err = db.DB.Query(`SELECT
			email
			FROM users
			WHERE email = $1`, email)
	default:
		log.Fatalf("Invalid user type")
	}
	if err != nil {
		log.Fatalf("Error checking if email is in database: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var dbEmail string
		if err := rows.Scan(&dbEmail); err != nil {
			log.Println(err)
		}
		if dbEmail == email {
			return true
		}
	}
	return false
}
