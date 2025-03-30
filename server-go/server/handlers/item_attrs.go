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

func GetItemAttrs(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	r := req.PathValue("id")
	id, err := strconv.ParseInt(r, 10, 64)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not parse id, try again later."))
		log.Println(err)
		return
	}

	rows, err := q.GetItemAttrsQuery(id)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get item attrs from database %s", err))
		return
	}
	defer rows.Close()

	var itemAttrs []models.ItemAttributes
	for rows.Next() {
		var itemAttr models.ItemAttributes
		if err := rows.Scan(
			&itemAttr.Attr_name,
			&itemAttr.Attr_value,
			); err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not decode request body %s", err))
			return
		}

		itemAttrs = append(itemAttrs, itemAttr)
	}

	json.NewEncoder(res).Encode(itemAttrs)
}

func CreateItemAttrs(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var itemAttr *models.ItemAttrs
	err := json.NewDecoder(req.Body).Decode(&itemAttr)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not decode request body %s", err))
		return
	}

	r := req.PathValue("id")
	id, err := strconv.ParseInt(r, 10, 64)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not parse id, try again later."))
		log.Println(err)
		return
	}

	err = q.CreateItemAttrsQuery(itemAttr, id)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not add item type to database %s", err))
		return
	}

	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("Successfully added item attribute"),
	})
}
