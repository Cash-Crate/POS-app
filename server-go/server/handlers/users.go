package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/Cash-Crate/POS-app/server/queries"
	"github.com/Cash-Crate/POS-app/server/utilities"
)

type UserResponse struct {
	User_id    int       `json:"user_id"`
	First_name string    `json:"first_name"`
	Last_name  string    `json:"last_name"`
	Username   string    `json:"username"`
	Email      string    `json:"email"`
	Birthdate  time.Time `json:"birthdate"`
	Address    string    `json:"address"`
	Phone_num  string    `json:"phone_num"`
	Role       string    `json:"role"`
}

type UserRequest struct {
	First_name string    `json:"first_name"`
	Last_name  string    `json:"last_name"`
	Email      string    `json:"email"`
	Password   string    `json:"password"`
	Birthdate  time.Time `json:"birthdate"`
	Address    string    `json:"address"`
	Phone_num  string    `json:"phone_num"`
	Role       string    `json:"role"`
}

func GetUsers(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	rows, err := queries.GetUsersQuery()
	if err != nil {
		utilities.ErrorRes(res, http.StatusInternalServerError,
			"Could not get users from database")
		return
	}
	defer rows.Close()

	var users []UserResponse
	for rows.Next() {
		var user UserResponse
		if err := rows.Scan(
			&user.User_id,
			&user.First_name,
			&user.Last_name,
			&user.Username,
			&user.Email,
			&user.Birthdate,
			&user.Address,
			&user.Phone_num,
			&user.Role); err != nil {
			utilities.ErrorRes(res, http.StatusInternalServerError,
				"Could not decode request body")
			return
		}
		users = append(users, user)
	}

	if err := rows.Err(); err != nil {
		utilities.ErrorRes(res, http.StatusInternalServerError,
			"Error during row iteration")
		return
	}

	json.NewEncoder(res).Encode(users)
}
