package models

type ItemType struct {
	Item_type_id    int    `json:"item_type_id"`
	Item_type_name  string `json:"item_type_name"`
}

type ItemTypeRequest struct {
	Item_type_name string `json:"item_type_name"`
}
