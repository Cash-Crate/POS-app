package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

func GetItemsQuery() ([]models.ItemWithAttrs, error) {
	var items []models.ItemWithAttrs

	rows, err := db.DB.Query(`SELECT
		i.item_id,
		i.item_name,
		i.description,
		i.item_image,
		i.price,
		i.quantity,
		it.item_type_name as item_type
		FROM items i
		JOIN item_types it ON it.item_type_id = i.item_type`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	itemIDs := []int64{}

	var dbQuan sql.NullInt64
	for rows.Next() {
		var item models.ItemWithAttrs
		if err := rows.Scan(
			&item.Item_id,
			&item.Item_name,
			&item.Description,
			&item.Item_image,
			&item.Price,
			&dbQuan,
			&item.Item_type,
		); err != nil {
			return nil, err
		}
		item.Quantity = int(dbQuan.Int64)
		items = append(items, item)
		itemIDs = append(itemIDs, int64(item.Item_id))
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	for i, item := range items {
		attrRows, err := db.DB.Query(`SELECT
			attr_name,
			attr_value
			FROM item_attributes
			WHERE item_id = $1`, item.Item_id)
		if err != nil {
			return nil, err
		}

		var attrs []models.ItemAttributes
		for attrRows.Next() {
			var attr models.ItemAttributes
			err := attrRows.Scan(
				&attr.Attr_name,
				&attr.Attr_value,
			)
			if err != nil {
				return nil, err
			}
			attrs = append(attrs, attr)
		}
		attrRows.Close()

		if err := attrRows.Err(); err != nil {
			return nil, err
		}
		items[i].Attrs = attrs
	}
	return items, nil
}

// FIRST SOLUTION
func GetItemByIDQuery(id int64) (models.ItemWithAttrs, error) {
	var item models.ItemWithAttrs
	var attrs []models.ItemAttributes
	var dbQuan sql.NullInt64

	itemErr := db.DB.QueryRow(`SELECT
		i.item_id,
		i.item_name,
		i.description,
		i.item_image,
		i.price,
		i.quantity,
		it.item_type_name as item_type
		FROM items i
		JOIN item_types it ON it.item_type_id = i.item_type
		WHERE i.item_id = $1`, id).Scan(
		&item.Item_id,
		&item.Item_name,
		&item.Description,
		&item.Item_image,
		&item.Price,
		&dbQuan,
		&item.Item_type,
	)
	item.Quantity = int(dbQuan.Int64)

	if itemErr != nil {
		return item, itemErr
	}

	attrRows, attrErr := db.DB.Query(`SELECT
		attr_name,
		attr_value
		FROM item_attributes
		WHERE item_id = $1`, id)

	if attrErr != nil {
		return item, attrErr
	}
	defer attrRows.Close()

	for attrRows.Next() {
		var attr models.ItemAttributes
		err := attrRows.Scan(
			&attr.Attr_name,
			&attr.Attr_value,
		)
		if err != nil {
			return item, err
		}
		attrs = append(attrs, attr)
	}

	if err := attrRows.Err(); err != nil {
		return item, err
	}

	item.Attrs = attrs
	return item, nil
}

func CreateItemQuery(item *models.ItemRequest) (int, error) {
	var insertedId int

	err := db.DB.QueryRow(`INSERT INTO items(
		item_name,
		description,
		item_type,
		item_image,
		price,
		quantity) VALUES (
		$1,
		$2,
		$3,
		$4,
		$5,
		$6) RETURNING item_id`,
		item.Item_name,
		item.Description,
		item.Item_type,
		item.Item_image,
		item.Price,
		item.Quantity).Scan(&insertedId)
	if err != nil {
		return 0, err
	}

	return insertedId, nil
}

func UpdateItemQuery(item *models.ItemRequest, id int64) (int64, error) {
	var existingItem models.ItemRequest
	err := db.DB.QueryRow(`SELECT item_name, description, item_type, item_image, price, quantity 
                          FROM items WHERE item_id = $1`, id).Scan(
		&existingItem.Item_name,
		&existingItem.Description,
		&existingItem.Item_type,
		&existingItem.Item_image,
		&existingItem.Price,
		&existingItem.Quantity,
	)
	if err != nil {
		return 0, err
	}

	updatedName := existingItem.Item_name
	if item.Item_name != "" {
		updatedName = item.Item_name
	}

	updatedDescription := existingItem.Description
	if item.Description != "" {
		updatedDescription = item.Description
	}

	updatedType := existingItem.Item_type
	if item.Item_type != 0 {
		updatedType = item.Item_type
	}

	updatedImage := existingItem.Item_image
	if item.Item_image != "" {
		updatedImage = item.Item_image
	}

	updatedPrice := existingItem.Price
	if item.Price != 0 {
		updatedPrice = item.Price
	}

	updatedQuantity := existingItem.Quantity
	if item.Quantity != 0 {
		updatedQuantity = item.Quantity
	}

	result, err := db.DB.Exec(`UPDATE items
        SET item_name = $1,
        description = $2,
        item_type = $3,
        item_image = $4,
        price = $5,
        quantity = $6
        WHERE item_id = $7
        RETURNING item_id`,
		updatedName,
		updatedDescription,
		updatedType,
		updatedImage,
		updatedPrice,
		updatedQuantity,
		id)
	if err != nil {
		return 0, err
	}
	rows, err := result.RowsAffected()
	return rows, err
}

func SellItemQuery(id, quantity int64) (int64, error) {
	result, err := db.DB.Exec(`UPDATE items
		SET quantity = quantity - $2
		WHERE item_id = $1
		RETURNING item_id`,
		id,
		quantity)
	if err != nil {
		return 0, err
	}
	rows, err := result.RowsAffected()
	return rows, err
}

func DeleteItemQuery(id int64) (int64, error) {
	result, err := db.DB.Exec(`DELETE FROM items WHERE item_id = $1`, id)
	if err != nil {
		return 0, err
	}
	rows, err := result.RowsAffected()
	return rows, err
}

// select it.item_type_name as item_type, i.item_id, i.item_name as name, i.description, i.item_image as image, i.price, i.quantity, ia.attr_name, ia.attr_value from items i join item_types it on it.item_type_id = i.item_type join item_attributes ia on ia.item_id = i.item_id;
// func GetItemByIDQuery(id int64) (models.ItemResponse, error) {
// 	var item models.ItemResponse
// 	err := db.DB.QueryRow(`SELECT
// 		item_id,
// 		item_name,
// 		description,
// 		item_type,
// 		item_image,
// 		price,
// 		quantity
// 		FROM items
// 		WHERE item_id = $1`, id).
// 		Scan(&item.Item_id,
// 			&item.Item_name,
// 			&item.Description,
// 			&item.Item_type,
// 			&item.Item_image,
// 			&item.Price,
// 			&item.Quantity,
// 		)
// 	if err != nil {
// 		return item, err
// 	}
// 	return item, nil
// }

// SECOND SOLUTION
// internal item with attributes
// type ItemWithAttrs struct {
// 	Item_id     int               `json:"item_id"`
// 	Item_name   string            `json:"item_name"`
// 	Description string            `json:"item_desc"`
// 	Item_image  string            `json:"item_image"`
// 	Price       float64           `json:"price"`
// 	Quantity    sql.NullInt64     `json:"quantity"`
// 	Item_type   string            `json:"item_type_name"`
// 	Attributes  map[string]string `json:"-"`
// }
//
// func (i ItemWithAttrs) MarshalJSON() ([]byte, error) {
// 	result := map[string]any{
// 		"item_id":    i.Item_id,
// 		"item_name":  i.Item_name,
// 		"item_desc":  i.Description,
// 		"item_image": i.Item_image,
// 		"price":      i.Price,
// 		"quantity":   i.Quantity,
// 		"item_type_name":  i.Item_type,
// 	}
//
// 	for key, value := range i.Attributes {
// 		result[key] = value
// 	}
//
// 	return json.Marshal(result)
// }
//
// func GetItemByIDQuery(id int64) (ItemWithAttrs, error) {
// 	var item ItemWithAttrs
//
// 	item.Attributes = make(map[string]string)
//
// 	rows, err := db.DB.Query(`SELECT
// 		it.item_type_name as item_type,
// 		i.item_id,
// 		i.item_name,
// 		i.description,
// 		i.item_image,
// 		i.price,
// 		i.quantity,
// 		ia.attr_name,
// 		ia.attr_value
// 		FROM items i
// 		JOIN item_types it ON it.item_type_id = i.item_type
// 		JOIN item_attributes ia ON ia.item_id = i.item_id
// 		WHERE i.item_id = $1`, id)
// 	if err != nil {
// 		return item, err
// 	}
//
// 	isFirstRow := true
// 	for rows.Next() {
// 		var attrName, attrValue string
//
// 		if isFirstRow {
// 			err = rows.Scan(
// 				&item.Item_type,
// 				&item.Item_id,
// 				&item.Item_name,
// 				&item.Description,
// 				&item.Item_image,
// 				&item.Price,
// 				&item.Quantity,
// 				&attrName,
// 				&attrValue,
// 			)
// 			isFirstRow = false
// 		} else {
// 			var itemType string
// 			var itemId int
// 			var itemName, description, itemImage string
// 			var price float64
// 			var quantity sql.NullInt64
//
// 			err = rows.Scan(
// 				&itemType,
// 				&itemId,
// 				&itemName,
// 				&description,
// 				&itemImage,
// 				&price,
// 				&quantity,
// 				&attrName,
// 				&attrValue,
// 			)
// 		}
//
// 		if err != nil {
// 			return item, err
// 		}
//
// 		item.Attributes[attrName] = attrValue
// 	}
//
// 	if err = rows.Err(); err != nil {
// 		return item, err
// 	}
//
// 	return item, nil
// }
