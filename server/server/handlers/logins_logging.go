package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"strconv"
	"time"

	"github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
	"github.com/mileusna/useragent"
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
		var logout sql.NullTime
		var log_in time.Time

		if err := rows.Scan(
			&login.Email,
			&log_in,
			&logout,
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
		login.Logout_at = logout.Time.Format("2006-01-02 15:04:05")
		login.Login_at = log_in.Format("2006-01-02 15:04:05")

		logins = append(logins, login)
	}
	json.NewEncoder(res).Encode(logins)
}

func PostLogin(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var anyType map[string]any
	user := models.LoginsRequest{}
	host := ""

	err := json.NewDecoder(req.Body).Decode(&anyType)
	if err != nil {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("Could not decode request body %s", err))
		log.Printf("Could not decode request body %s", err)
		return
	}
	fmt.Printf("User ID: %v", anyType["user_id"])

	userIDFloat, err := strconv.Atoi(anyType["user_id"].(string))

	userAgent := useragent.Parse(req.UserAgent())
	userAgent2 := req.UserAgent()[13:]
	deviceInfo := util.ParseUserAgent(userAgent2)
	var ipAddr string

	if (req.Header.Get("X-Original-Forwarded-For") != "") {
		ipAddr = req.Header.Get("X-Original-Forwarded-For")
	} else if (req.Header.Get("X-Forwarded-For") != "") {
		ipAddr = req.Header.Get("X-Forwarded-For")
	} else if (req.Header.Get("X-Real-IP") != "") {
		ipAddr = req.Header.Get("X-Real-IP")
	} else {
		host, _, err = net.SplitHostPort(req.RemoteAddr)
		if err != nil {
			log.Printf("Could not parse IP address: %s", err)
			util.ErrorRes(res, http.StatusBadRequest,
				"Invalid IP address format")
		return
		}
	}
	if ipAddr == "" {
		ipAddr = host
	}

	user.User_id = int(userIDFloat)
	user.Ip_addr = ipAddr
	user.Device_type = fmt.Sprintf("%s %s", deviceInfo.Device, deviceInfo.OS)
	user.Browser = fmt.Sprintf("%s %s", userAgent.Name, userAgent.Version)
	user.Cpu_arch = deviceInfo.CPUArchitecture
	user.Host = req.Host
	user.Origin = req.Header.Get("Origin")

	err = q.CreateLoginsQuery(user)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not create logins in database %s", err))
		log.Printf("Could not create logins in database %s", err)
		return
	}

	// userId := strconv.Itoa(user.User_id)
	// json.NewEncoder(res).Encode(map[string]string{
	// 	"message": "real",
	// 	"user_id": userId,
	// 	"user_ip": user.Ip_addr,
	// 	"user_dev": user.Device_type,
	// 	"user_browser": user.Browser,
	// 	"user_cpu": user.Cpu_arch,
	// 	"user_host": user.Host,
	// 	"user_origin": user.Origin,
	// })
	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: "Successfully logged log in",
	})
}
