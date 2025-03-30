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

func CreateItemAttrQuery(item_attrs *models.ItemAttrs, id int64) (error) {
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

func UpdateItemAttrQuery(name, value string, id int64) (int64, error) {
	res, err := db.DB.Exec(`UPDATE item_attributes
		SET attr_value = $1
		WHERE item_id = $2 
		AND attr_name = $3`, value, id, name)
	if err != nil {
		return 0, err
	}

	rows, err := res.RowsAffected()
	return rows, nil
}
