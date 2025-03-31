package models

type LoginResponse struct {
	Email       string `json:"email"`
	Login_at    string `json:"login_at"`
	Logout_at   string `json:"logout_at"`
	Ip_addr     string `json:"ip_addr"`
	Device_type string `json:"device_type"`
	Browser     string `json:"browser"`
	Cpu_arch    string `json:"cpu_arch"`
	Host        string `json:"host"`
	Origin      string `json:"origin"`
}
