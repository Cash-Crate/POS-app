package queries

import (

	db "github.com/Cash-Crate/POS-app/server/database"
)

func LogInQuery(email, password string) (int, error) {
	var userID int
	query := `select user_id from users 
	where email = $1 and password = $2`
	err := db.DB.QueryRow(query, email, password).Scan(&userID)
	if err != nil {
		return 0, err
	}

	return userID, nil
}
