package queries

import (
	"database/sql"
	"fmt"

	db "github.com/Cash-Crate/POS-app/server/database"
)

func GetLoginsQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT
		login_id,
		user_id,
		login_at,
		logout_at,
		ip_addr,
		device_type,
		browser,
		cpu_arch,
		host,
		origin FROM logins_logging`)
	if err != nil {
		return nil, fmt.Errorf("Could not query database %s", err)
	}

	return rows, nil
}
