package utilities

import (
	"encoding/json"
	"log"
	"net/http"
	"net/mail"
	"regexp"
	"strings"

	db "github.com/Cash-Crate/POS-app/server/database"
)

type ErrorResponse struct {
	Error string `json:"error"`
}

type OkResponse struct {
	Message string `json:"message"`
}

func ErrorRes(res http.ResponseWriter, status int, mess string) {
	res.WriteHeader(status)
	json.NewEncoder(res).Encode(ErrorResponse{
		Error: mess,
	})
}

func IsEmailValid(email string) bool {
	if _, err := mail.ParseAddress(email); err != nil {
		return false
	}
	return true
}

func IsEmailInDB(email string, ut string) bool {
	var exists bool
	ut = strings.ToLower(ut)

	query := "SELECT EXISTS(SELECT 1 FROM users WHERE email = $1)"

	err := db.DB.QueryRow(query, email).Scan(&exists)
	if err != nil {
		log.Printf("Error checking email existence: %v", err)
		return false
	}
	return exists
}

func IsItemTypeInDB(itemType string) bool {
	var exists bool

	err := db.DB.QueryRow(`SELECT EXISTS(SELECT
		1 FROM item_types WHERE item_type_name = $1)`,
		itemType).Scan(&exists)
	if err != nil {
		log.Fatalf("Error checking if item type exists: %v", err)
		return false
	}
	return exists
}

type DeviceInfo struct {
	OS              string `json:"os"`
	Device          string `json:"device"`
	CPUArchitecture string `json:"cpu_architecture"`
}

func ParseUserAgent(userAgent string) DeviceInfo {
	info := DeviceInfo{}

	switch {
	case strings.Contains(userAgent, "Windows NT"):
		info.OS = "Windows"
		info.Device = "Desktop"
	case strings.Contains(userAgent, "Macintosh"):
		info.OS = "macOS"
		info.Device = "Mac"
	case strings.Contains(userAgent, "iPhone"):
		info.OS = "iOS"
		info.Device = "iPhone"
	case strings.Contains(userAgent, "iPad"):
		info.OS = "iOS"
		info.Device = "iPad"
	case strings.Contains(userAgent, "Android"):
		info.OS = "Android"
		if strings.Contains(userAgent, "Mobile") {
			info.Device = "Phone"
		} else {
			info.Device = "Tablet"
		}
	case strings.Contains(userAgent, "Linux"):
		info.OS = "Linux"
		info.Device = "Desktop"
	default:
		info.OS = "Unknown"
		info.Device = "Unknown"
	}

	if match, _ := regexp.MatchString(`Win64; x64`, userAgent); match {
		info.CPUArchitecture = "x86_64"
	} else if match, _ := regexp.MatchString(`WOW64`, userAgent); match {
		info.CPUArchitecture = "x86_64"
	} else if match, _ := regexp.MatchString(`Win64; ARM64`, userAgent); match {
		info.CPUArchitecture = "aarch64"
	}

	if strings.Contains(userAgent, "Intel Mac OS X") {
		info.CPUArchitecture = "x86_64"
	} else if strings.Contains(userAgent, "iPhone") || strings.Contains(userAgent, "iPad") {
		info.CPUArchitecture = "arm64"
	}

	if match, _ := regexp.MatchString(`Linux x86_64`, userAgent); match {
		info.CPUArchitecture = "x86_64"
	} else if match, _ := regexp.MatchString(`Linux aarch64`, userAgent); match {
		info.CPUArchitecture = "aarch64"
	} else if match, _ := regexp.MatchString(`Linux armv`, userAgent); match {
		info.CPUArchitecture = "arm"
	}

	if strings.Contains(userAgent, "Android") {
		info.CPUArchitecture = "arm64"
		modelRegex := regexp.MustCompile(`Android [0-9\.]+; ([^)]+)`)
		matches := modelRegex.FindStringSubmatch(userAgent)

		if len(matches) > 1 {
			model := matches[1]

			if strings.Contains(model, "SM-G") {
				if strings.Contains(model, "SM-G955U") || strings.Contains(model, "SM-G981B") {
					if strings.Contains(model, "SM-G955U") {
						info.CPUArchitecture = "arm64 (Exynos)"
					} else if strings.Contains(model, "SM-G981B") {
						info.CPUArchitecture = "arm64 (Snapdragon)"
					}
				}
			}
		}
	}

	if info.CPUArchitecture == "" {
		info.CPUArchitecture = "Unknown"
	}
	return info
}
