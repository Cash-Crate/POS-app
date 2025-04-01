package server

import (
	"log"

	"github.com/Cash-Crate/POS-app/server/database"
)

func CreateSchema() {
	_, err := database.DB.Exec(`CREATE TABLE IF NOT EXISTS users (
		user_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		first_name TEXT NOT NULL,
		last_name TEXT NOT NULL,
		email TEXT NOT NULL,
		password TEXT NOT NULL,
		birthdate DATE NOT NULL,
		address TEXT NOT NULL,
		phone_num TEXT NOT NULL,
		role TEXT NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS logins_logging (
		login_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
		login_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		logout_at TIMESTAMPTZ,
		ip_addr INET NOT NULL,
		device_type TEXT NOT NULL,
		browser TEXT NOT NULL,
		cpu_arch TEXT NOT NULL,
		host TEXT NOT NULL,
		origin TEXT NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS crud_logging (
		action_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
		action_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		action_taken TEXT NOT NULL,
		item_id INT NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS item_types (
		item_type_name TEXT NOT NULL PRIMARY KEY
		) `)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS items (
		item_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		item_name TEXT NOT NULL,
		description TEXT,
		item_type TEXT NOT NULL REFERENCES item_types(item_type_name),
		item_image TEXT,
		price NUMERIC(10,2) NOT NULL,
		quantity INT NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS item_attributes (
		item_id INTEGER NOT NULL REFERENCES items(item_id) ON DELETE CASCADE,
		PRIMARY KEY(item_id, attr_name),
		attr_name TEXT NOT NULL,
		attr_value TEXT NOT NULL
		) `)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS onetime_trans (
		trans_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		trans_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
		item_count INTEGER NOT NULL,
		cost_total NUMERIC(10,2) NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS recurring_trans (
		trans_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		cost_total NUMERIC(10,2) NOT NULL,
		item_count INTEGER NOT NULL,
		start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		end_date TIMESTAMP,
		month_fee NUMERIC(10,2),
		year_fee NUMERIC(10,2),
		user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE 
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS recurring_trans_payment (
		trans_id INTEGER NOT NULL REFERENCES recurring_trans(trans_id) ON DELETE CASCADE,
		payment_rcvd NUMERIC(10,2) NOT NULL,
		date_rcvd TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
		)`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}

	_, err = database.DB.Exec(`CREATE TABLE IF NOT EXISTS bought_items (
		item_id INTEGER NOT NULL REFERENCES items(item_id),
		onetime_trans_id INTEGER,
		recurring_trans_id INTEGER,
		num_item INTEGER NOT NULL,
		items_cost NUMERIC(10,2) NOT NULL,

		-- Ensure exactly one transaction ID is not null
		CoNsTrAiNt xor_transaction_ids CHECK (
		(onetime_trans_id IS NULL AND recurring_trans_id IS NOT NULL) OR
		(onetime_trans_id IS NOT NULL AND recurring_trans_id IS NULL)
		),

		-- Composite primary key with onetime_trans_id when it's used
		CONSTRAINT pk_onetime_item UNIQUE (item_id, onetime_trans_id) 
		DEFERRABLE INITIALLY DEFERRED,

		-- Composite primary key with recurring_trans_id when it's used
		CONSTRAINT pk_recurring_item UNIQUE (item_id, recurring_trans_id)
		DEFERRABLE INITIALLY DEFERRED
		);`)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}
}
