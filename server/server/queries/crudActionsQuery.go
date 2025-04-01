package queries

import (
	"database/sql"
	"log"

	db "github.com/Cash-Crate/POS-app/server/database"
)

func GetCrudActionsQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT 
		action_id,
		user_id,
		action_at,
		action_taken,
		item_id from crud_logging`)
	if err != nil {
		return nil, err
	}
	return rows, nil
}

func CreateCrudActionQuery(userID int, action string, itemID int) {
	query := "INSERT INTO crud_logging (user_id, action_taken, item_id) VALUES ($1, $2, $3)"
	_, err := db.DB.Exec(query, userID, action, itemID)
	if err != nil {
		log.Println("Failed to log action:", err)
	}
}
