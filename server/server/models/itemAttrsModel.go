package models

type ItemAttrs struct {
	Attr_name string `json:"attr_name"`
	Attr_value string `json:"attr_value"`
}

type ItemAttrsUpdate struct {
	Attr_value string `json:"attr_value"`
}
