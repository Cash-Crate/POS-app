package handlers

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	user "github.com/Cash-Crate/POS-app/server/models"
	q "github.com/Cash-Crate/POS-app/server/queries"
	util "github.com/Cash-Crate/POS-app/server/utilities"
)

func GetUsers(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")

	rows, err := q.GetUsersQuery()
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not get users from database %s", err))
		return
	}
	defer rows.Close()

	var users []user.UserResponse
	for rows.Next() {
		var user user.UserResponse
		var birthdate time.Time

		if err := rows.Scan(
			&user.User_id,
			&user.First_name,
			&user.Last_name,
			&user.Username,
			&user.Email,
			&birthdate,
			&user.Address,
			&user.Phone_num,
			&user.Role); err != nil {
			util.ErrorRes(res, http.StatusInternalServerError,
				fmt.Sprintf("Could not decode request body %s", err))
			return
		}
		user.Birthdate = birthdate.Format("2006-01-02")

		users = append(users, user)
	}

	if err := rows.Err(); err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Error during row iteration %s", err))
		return
	}

	json.NewEncoder(res).Encode(users)
}

func GetUserByID(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	user_id := req.URL.Query().Get("id")
	user_id_int, err := strconv.ParseInt(user_id, 10, 64)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not parse id, try again later."))
		log.Println(err)
		return
	}

	rows, err := q.GetUserByIdQuery(user_id_int)
	if err != nil {
		util.ErrorRes(res, http.StatusBadRequest,
			fmt.Sprintf("No user with this id"))
		log.Println(err)
		return
	}

	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("%v", rows.Email),
	})
}

func CreateUser(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var user *user.UserRequest
	err := json.NewDecoder(req.Body).Decode(&user)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not decode request body %s", err))
		return
	}

	if util.IsEmailInDB(user.Email, "admin") {
		util.ErrorRes(res, http.StatusBadRequest,
			"Email already exists")
		return
	}

	insertedId, err := q.CreateUserQuery(user)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not add user to database %s", err))
		return
	}

	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("User %d", insertedId),
	})
}

func DeleteUser(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	user_id := req.URL.Query().Get("id")
	user_id_int, err := strconv.ParseInt(user_id, 10, 64)
	fmt.Println(user_id)
	fmt.Println(user_id_int)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not parse id, try again later."))
		log.Println(err)
		return
	}

	rows, err := q.DeleteUserQuery(user_id_int)
	if err != nil {
		util.ErrorRes(res, http.StatusInternalServerError,
			fmt.Sprintf("Could not delete user, try again later."))
		log.Println(err)
		return
	}

	if rows == 0 {
		json.NewEncoder(res).Encode(util.OkResponse{
			Message: "User not found",
		})
		return
	}

	res.WriteHeader(http.StatusCreated)
	json.NewEncoder(res).Encode(util.OkResponse{
		Message: fmt.Sprintf("User deleted successfully. %d rows affected", rows),
	})
}
