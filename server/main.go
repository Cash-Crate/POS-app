package main

import (
	"github.com/Cash-Crate/POS-app/server"
	"github.com/Cash-Crate/POS-app/server/database"
	_ "github.com/lib/pq"
)

func main() {
	database.ConnDB()
	server.CreateSchema()
	server.ServeHttp()
}
