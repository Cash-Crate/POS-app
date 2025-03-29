package queries

import (
	"database/sql"

	db "github.com/Cash-Crate/POS-app/server/database"
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

func CreateUserQuery() {

}
