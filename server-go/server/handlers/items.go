package handlers

import (
	"encoding/json"
	"fmt"
	"log"
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

func UpdateItem(res http.ResponseWriter, req *http.Request) {
    res.Header().Set("Content-Type", "application/json")
    var item *models.ItemRequest
    err := json.NewDecoder(req.Body).Decode(&item)
    if err != nil {
        util.ErrorRes(res, http.StatusInternalServerError,
            fmt.Sprintf("Could not decode request body %s", err))
        return
    }
    r := req.PathValue("id")
    id, err := strconv.ParseInt(r, 10, 64)
    if err != nil {
        util.ErrorRes(res, http.StatusInternalServerError,
            fmt.Sprintf("Could not parse id %s", err))
        return
    }
    rows, err := q.UpdateItemQuery(item, id)
    if err != nil {
        util.ErrorRes(res, http.StatusInternalServerError,
            fmt.Sprintf("Could not update item: %s", err))
        log.Println(err)
        return
    }
    if rows == 0 {
        json.NewEncoder(res).Encode(util.ErrorResponse{
            Error: "Item not found",
        })
        return
    }
    res.WriteHeader(http.StatusCreated)
    json.NewEncoder(res).Encode(util.OkResponse{
        Message: fmt.Sprintf("Item updated successfully. %d rows affected", rows),
    })
}

func SellItem(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	r := req.PathValue("id")
	id, err := strconv.ParseInt(r, 10, 64)
	if err != nil || id == 0 {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("Could not parse id %s", err))
		return
	}

	quan := req.PathValue("quantity")
	quantity, err := strconv.ParseInt(quan, 10, 64)
	if err != nil || quantity == 0 {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("Could not parse quantity %s", err))
		return
	}

	rows, err := q.SellItemQuery(id, quantity)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not sell item: %s", err))
		log.Println(err)
		return
	}
	if rows == 0 {
		json.NewEncoder(res).Encode(util.ErrorResponse{
			Error: "Item not found",
		})
		return
	}
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("Item sold successfully. %d rows affected", rows),
	})
}

func DeleteItem(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	r := req.PathValue("id")
	id, err := strconv.ParseInt(r, 10, 64)
	if err != nil || id == 0 {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("Could not parse id %s", err))
		return
	}

	rows, err := q.DeleteItemQuery(id)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not delete item: %s", err))
		log.Println(err)
		return
	}

	if rows == 0 {
		json.NewEncoder(res).Encode(util.ErrorResponse{
			Error: "Item not found",
		})
		return
	}

	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("Item deleted successfully. %d rows affected", rows),
	})
}
