package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetItems(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	items, err := q.GetItemsQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get items from database %s", err))
		return
	}
	json.NewEncoder(res).Encode(items)
}

func GetItemByID(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	r := req.PathValue("id")
	id, err := strconv.ParseInt(r, 10, 64)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not parse id %s", err))
		return
	}

	item, err := q.GetItemByIDQuery(id)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get item by id %s", err))
		return
	}

	json.NewEncoder(res).Encode(item)
}

func CreateItem(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var item *models.ItemRequest
	err := json.NewDecoder(req.Body).Decode(&item)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not decode request body %s", err))
		return
	}

	insertedId, err := q.CreateItemQuery(item)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not add item to database %s", err))
		return
	}

	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("Item %d", insertedId),
	})
}
