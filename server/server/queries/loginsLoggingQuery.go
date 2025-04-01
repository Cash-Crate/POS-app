package queries

import (
	"database/sql"
	"fmt"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

func GetLoginsQuery() (*sql.Rows, error) {
	rows, err := db.DB.Query(`SELECT
		l.login_id,
		u.email,
		l.login_at AT TIME ZONE 'Asia/Manila',
		l.logout_at AT TIME ZONE 'Asia/Manila',
		l.ip_addr,
		l.device_type,
		l.browser,
		l.cpu_arch,
		l.host,
		l.origin 
		FROM logins_logging l
		JOIN users u ON l.user_id = u.user_id;`)
	if err != nil {
		return nil, fmt.Errorf("Could not query database %s", err)
	}

	return rows, nil
}

func CreateLoginsQuery(user models.LoginsRequest) (int, error) {
	var insID int
	err := db.DB.QueryRow(`INSERT INTO logins_logging (user_id,
		ip_addr, device_type, browser, cpu_arch, host, origin) VALUES (
		$1, $2, $3, $4, $5, $6, $7) RETURNING login_id`, 
		user.User_id, user.Ip_addr, user.Device_type, user.Browser,
		user.Cpu_arch, user.Host, user.Origin).Scan(&insID)
	if err != nil {
		return 0, err
	}
	return insID, nil
}

func UpdateLoginsQuery(id int) error {
	_, err := db.DB.Exec(`UPDATE logins_logging
		SET logout_at = NOW() WHERE login_id = $1`, id)
	if err != nil {
		return err
	}
	return nil
}
