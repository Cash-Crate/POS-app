package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

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
