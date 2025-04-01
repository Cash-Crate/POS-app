package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetCrudActions(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	rows, err := q.GetCrudActionsQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get crud actions from database %s", err))
		return
	}
	defer rows.Close()

	var actions []models.CrudActionsResponse
	for rows.Next() {
		var action models.CrudActionsResponse
		var action_at time.Time
		err := rows.Scan(
			&action.Action_id,
			&action.User_id,
			&action_at,
			&action.Action_taken,
			&action.Item_id)
		if err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not decode request body %s", err))
			return
		}
		action.Action_at = action_at.Format("2006-01-02 15:04:05")
		actions = append(actions, action)
	}
	if err := rows.Err(); err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Error during row iteration %s", err))
		return
	}
	json.NewEncoder(res).Encode(actions)
}
