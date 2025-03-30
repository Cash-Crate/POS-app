package models

type CrudActionsResponse struct {
	Action_id        int    `json:"action_id"`
	User_id          int    `json:"user_id"`
	Action_at        string `json:"action_at"`
	Action_taken     string `json:"action_taken"`
	X_requested_with string `json:"x_requested_with"`
}
