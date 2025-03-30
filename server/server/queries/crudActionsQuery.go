package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
)

func GetCrudActionsQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT 
		action_id,
		user_id,
		action_at,
		action_taken,
		x_requested_with from crud_logging`)
	if err != nil {
		return nil, err
	}
	return rows, nil
}
