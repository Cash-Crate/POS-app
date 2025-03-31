package handlers

import (
	"encoding/json"
	"net/http"
)

func GetRoot(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	json.NewEncoder(res).Encode(map[string]string{"message": "Hello World"})
}
