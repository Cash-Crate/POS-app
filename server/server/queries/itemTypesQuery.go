package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

func GetItemTypesQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT
		item_type_name
		FROM item_types`)
	if err != nil {
		return nil, err
	}
	return rows, nil
}

func CreateItemTypeQuery(itemType *models.ItemTypeRequest) (int, error) {
	_, err := db.DB.Exec(`INSERT INTO item_types(
		item_type_name) VALUES ($1)`,
		itemType.Item_type_name)
	if err != nil {
		return 0, err
	}

	return 1, nil
}
