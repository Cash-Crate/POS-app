package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
)

func GetItemsQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT
		item_id,
		item_name,
		description,
		item_type,
		item_image,
		price,
		quantity
		FROM items`)
	if err != nil {
		return nil, err
	}
	return rows, nil
}
