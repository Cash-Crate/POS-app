package queries

import (
	"errors"

	db "github.com/Cash-Crate/POS-app/server/database"
)

func LogInQuery(email, password string) (int, error) {
	var userID int
	var userRole string
	query := `select user_id, role from users 
	where email = $1 and password = $2`
	err := db.DB.QueryRow(query, email, password).
		Scan(&userID, &userRole)
	if err != nil {
		return 0, err
	}

	if userRole != "admin" {
		return 0, errors.New("Unauthorized")
	}

	return userID, nil
}
