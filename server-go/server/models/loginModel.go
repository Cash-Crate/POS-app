package models

import "database/sql"

type LoginResponse struct {
	Login_id    int            `json:"login_id"`
	User_id     int            `json:"user_id"`
	Login_at    string         `json:"login_at"`
	Logout_at   sql.NullString `json:"logout_at"`
	Ip_addr     string         `json:"ip_addr"`
	Device_type string         `json:"device_type"`
	Browser     string         `json:"browser"`
	Cpu_arch    string         `json:"cpu_arch"`
	Host        string         `json:"host"`
	Origin      string         `json:"origin"`
}
