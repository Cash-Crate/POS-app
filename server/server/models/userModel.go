package models

type UserResponse struct {
	User_id    int    `json:"user_id"`
	First_name string `json:"first_name"`
	Last_name  string `json:"last_name"`
	Username   string `json:"username"`
	Email      string `json:"email"`
	Birthdate  string `json:"birthdate"`
	Address    string `json:"address"`
	Phone_num  string `json:"phone_num"`
	Role       string `json:"role"`
}

type UserRequest struct {
	First_name string `json:"first_name"`
	Last_name  string `json:"last_name"`
	Username   string `json:"username"`
	Email      string `json:"email"`
	Password   string `json:"password"`
	Birthdate  string `json:"birthdate"`
	Address    string `json:"address"`
	Phone_num  string `json:"phone_num"`
	Role       string `json:"role"`
}
