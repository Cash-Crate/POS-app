package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetItems(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	rows, err := q.GetItemsQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get items from database %s", err))
		return
	}
	defer rows.Close()

	var items []models.ItemResponse
	for rows.Next() {
		var item models.ItemResponse
		if err := rows.Scan(
			&item.Item_id,
			&item.Item_name,
			&item.Description,
			&item.Item_type,
			&item.Item_image,
			&item.Price,
			&item.Quantity,
			); err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not get items %s", err))
			return
		}
		items = append(items, item)
	}

	json.NewEncoder(res).Encode(items)
}
