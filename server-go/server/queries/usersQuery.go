package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

func GetUsersQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT 
		user_id,
		first_name,
		last_name,
		email,
		password,
		birthdate,
		address,
		phone_num,
		role from users`)
	if err != nil {
		return nil, err
	}
	return rows, nil
}

func GetUserByIdQuery(id int64) (models.UserResponse, error) {
	var user models.UserResponse
	err := db.DB.QueryRow(`SELECT
		user_id,
		first_name,
		last_name,
		username,
		email,
		birthdate,
		address,
		phone_num,
		role from users WHERE user_id = $1`, id).Scan(
		&user.User_id,
		&user.First_name,
		&user.Last_name,
		&user.Username,
		&user.Email,
		&user.Birthdate,
		&user.Address,
		&user.Phone_num,
		&user.Role)
	if err != nil {
		return user, err
	}
	return user, nil
}

func CreateUserQuery(user *models.UserRequest) (int, error) {
	var insertedId int

	err := db.DB.QueryRow(`INSERT INTO users(
		first_name,
		last_name,
		username,
		email,
		password,
		birthdate,
		address,
		phone_num,
		role) VALUES (
		$1,
		$2,
		$3,
		$4,
		$5,
		$6,
		$7,
		$8,
		$9) RETURNING user_id`,
		user.First_name,
		user.Last_name,
		user.Username,
		user.Email,
		user.Password,
		user.Birthdate,
		user.Address,
		user.Phone_num,
		user.Role).Scan(&insertedId)
	if err != nil {
		return 0, err
	}

	return insertedId, nil
}

func DeleteUserQuery(user_id int64) (int64, error) {
	result, err := db.DB.Exec(`DELETE FROM users WHERE user_id = $1`, user_id)
	if err != nil {
		return 0, err
	}
	rows, err := result.RowsAffected()
	return rows, err
}
