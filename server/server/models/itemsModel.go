package models

type ItemResponse struct {
	Item_id     int     `json:"item_id"`
	Item_name   string  `json:"item_name"`
	Description string  `json:"description"`
	Item_type   int     `json:"item_type"`
	Item_image  string  `json:"item_image"`
	Price       float64 `json:"price"`
	Quantity    int     `json:"quantity"`
}

type ItemWithAttrs struct {
	Item_id     int              `json:"item_id"`
	Item_name   string           `json:"item_name"`
	Description string           `json:"description"`
	Item_image  string           `json:"item_image"`
	Price       float64          `json:"price"`
	Quantity    int              `json:"quantity"`
	Item_type   string           `json:"item_type"`
	Attrs       []ItemAttributes `json:"attributes"`
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
