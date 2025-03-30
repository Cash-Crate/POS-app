package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

func GetItemAttrsQuery(id int64) (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT
		attr_name,
		attr_value
		FROM item_attributes
		WHERE item_id = $1`, id)
	if err != nil {
		return nil, err
	}
	return rows, nil
}

func CreateItemAttrsQuery(item_attrs *models.ItemAttrs, id int64) (error) {
	_, err := db.DB.Exec(`INSERT INTO item_attributes(
		item_id,
		attr_name,
		attr_value) VALUES (
		$1,
		$2,
		$3)`, 
		id, item_attrs.Attr_name, item_attrs.Attr_value)
	if err != nil {
		return err
	}
	return nil
}
