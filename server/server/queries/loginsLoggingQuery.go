package queries

import (
	"database/sql"
	"fmt"

	db "github.com/Cash-Crate/POS-app/server/database"
	"github.com/Cash-Crate/POS-app/server/models"
)

// TODO: MAKE THE LOGIN TIMES BETTER LOOKING

func GetLoginsQuery() (*sql.Rows, error) {
// select u.email, l.ip_addr, l.device_type, l.browser, l.cpu_arch, l.host, l.origin from logins_logging l join users u on l.user_id = u.user_id;
	rows, err := db.DB.Query(`SELECT
		u.email,
		l.login_at,
		l.logout_at,
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

func CreateLoginsQuery(user models.LoginsRequest) error {
	_, err := db.DB.Query(`INSERT INTO logins_logging (user_id,
		ip_addr, device_type, browser, cpu_arch, host, origin) VALUES (
		$1, $2, $3, $4, $5, $6, $7)`, 
		user.User_id, user.Ip_addr, user.Device_type, user.Browser,
		user.Cpu_arch, user.Host, user.Origin)
	if err != nil {
		return fmt.Errorf("Could not query database %s", err)
	}
	return nil
}
