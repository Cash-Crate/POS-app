package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetLogins(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	
	rows, err := q.GetLoginsQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get logins from database %s", err))
		return
	}
	defer rows.Close()

	var logins []models.LoginResponse
	for rows.Next() {
		var login models.LoginResponse

		if err := rows.Scan(
			&login.Login_id,
			&login.User_id,
			&login.Login_at,
			&login.Logout_at,
			&login.Ip_addr,
			&login.Device_type,
			&login.Browser,
			&login.Cpu_arch,
			&login.Host,
			&login.Origin); err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not decode request body %s", err))
			return
		}

		logins = append(logins, login)
	}
	json.NewEncoder(res).Encode(logins)
}
