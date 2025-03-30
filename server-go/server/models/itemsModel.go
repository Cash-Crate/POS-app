package models

import "database/sql"

type ItemResponse struct {
	Item_id     int           `json:"item_id"`
	Item_name   string        `json:"item_name"`
	Description string        `json:"description"`
	Item_type   int           `json:"item_type"`
	Item_image  string        `json:"item_image"`
	Price       float64       `json:"price"`
	Quantity    sql.NullInt64 `json:"quantity"`
}

// type ItemWithAttrs struct {
// 	Item_type   string        `json:"item_type"`
// 	Item_id     int           `json:"item_id"`
// 	Item_name   string        `json:"item_name"`
// 	Description string        `json:"description"`
// 	Item_image  string        `json:"item_image"`
// 	Price       float64       `json:"price"`
// 	Quantity    sql.NullInt64 `json:"quantity"`
// 	Attrs       []ItemAttributes
// }

type ItemWithAttrs struct {
	Item_type   string            `json:"item_type"`
	Item_id     int               `json:"item_id"`
	Item_name   string            `json:"item_name"`
	Description string            `json:"description"`
	Item_image  string            `json:"item_image"`
	Price       float64           `json:"price"`
	Quantity    sql.NullInt64     `json:"quantity"`
	Attributes  map[string]string `json:"-"`
}

type ItemAttributes struct {
	Attr_name  string `json:"attr_name"`
	Attr_value string `json:"attr_value"`
}

type ItemRequest struct {
	Item_name   string  `json:"item_name"`
	Description string  `json:"description"`
	Item_type   int     `json:"item_type"`
	Item_image  string  `json:"item_image"`
	Price       float64 `json:"price"`
	Quantity    int     `json:"quantity"`
}
