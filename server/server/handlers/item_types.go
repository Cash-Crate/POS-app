package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetItemTypes(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	rows, err := q.GetItemTypesQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get item types from database %s", err))
		return
	}
	defer rows.Close()

	var itemTypes []models.ItemType
	for rows.Next() {
		var itemType models.ItemType
		if err := rows.Scan(
			&itemType.Item_type_name); err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not decode request body %s", err))
			return
		}

		itemTypes = append(itemTypes, itemType)
	}

	json.NewEncoder(res).Encode(itemTypes)
}

func CreateItemType(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var itemType *models.ItemTypeRequest
	err := json.NewDecoder(req.Body).Decode(&itemType)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not decode request body %s", err))
		return
	}

	if util.IsItemTypeInDB(itemType.Item_type_name) {
		util.ErrorRes(res, http.StatusBadRequest,
			"Item Type already exists")
		return
	}

	_, err = q.CreateItemTypeQuery(itemType)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not add item type to database %s", err))
		return
	}

	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("Successfully created item type"),
	})
}
