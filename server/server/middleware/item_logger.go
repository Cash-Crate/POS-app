package middleware

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	q "github.com/Cash-Crate/POS-app/server/queries"
)

func atoiSafe(s string) int {
	n, err := strconv.Atoi(s)
	if err != nil {
		return 0
	}
	return n
}

func ItemLogger(next http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		authHeader := req.Header.Get("Authorization")
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		userID, ok := GetUserID(req.Context(), tokenString)
		if !ok {
			log.Println("No user ID found")
			next.ServeHTTP(res, req)
			return
		}

		parts := strings.Split(strings.Trim(req.URL.Path, "/"), "/")
		var actionTaken string
		var itemID int

		switch req.Method {
		case "POST":
			if len(parts) == 3 && parts[1] == "items" && parts[2] == "create" {
				itemIDStr := req.FormValue("id")
				itemID = atoiSafe(itemIDStr)
				actionTaken = fmt.Sprintf("Created new item")
			} else if len(parts) == 5 && parts[1] == "items" && parts[2] == "attrs" && parts[3] == "create" {
				itemID = atoiSafe(parts[4])
				actionTaken = fmt.Sprintf("Created new attributes for item %d", itemID)
			}

		case "PUT":
			if len(parts) == 3 && parts[1] == "items" {
				itemID = atoiSafe(parts[2])
				actionTaken = fmt.Sprintf("Updated item %d", itemID)
			} else if len(parts) == 4 && parts[1] == "items" {
				itemID = atoiSafe(parts[2])
				actionTaken = fmt.Sprintf("Sold %s units of item %d", parts[3], itemID)
			} else if len(parts) == 5 && parts[1] == "items" && parts[2] == "attrs" {
				itemID = atoiSafe(parts[3])
				actionTaken = fmt.Sprintf("Updated item attribute %s for item %d", parts[4], itemID)
			}

		case "DELETE":
			if len(parts) == 3 && parts[1] == "items" {
				itemID = atoiSafe(parts[2])
				actionTaken = fmt.Sprintf("Deleted item %d", itemID)
			}

		case "GET":
			if len(parts) == 4 && parts[1] == "items" && parts[2] == "attrs" {
				itemID = atoiSafe(parts[3])
				actionTaken = fmt.Sprintf("Fetched attributes for item %d", itemID)
			}
		}

		userIDInt := atoiSafe(userID)

		if actionTaken != "" {
			q.CreateCrudActionQuery(userIDInt, actionTaken, itemID)
		} else {
			log.Println("No recognized action for this request.")
		}

		next.ServeHTTP(res, req)
	})
}

