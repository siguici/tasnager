module main

import veb
import databases
import os

const port = 8082

fn main() {
	mut db := databases.create_db_connection() or { panic(err) }

	sql db {
		create table User
		create table Product
	} or { panic('error on create table: ${err}') }

	db.close() or { panic(err) }

	mut app := &App{
		secret_key: 'secret'
	}

	// Pass the App and context type and start the web server on port 8080
	app.serve_static('/favicon.ico', 'src/resources/favicon.ico')!
	// makes all static files available.
	app.mount_static_folder_at(os.resource_abs_path('./src'), '/')!

	veb.run[App, Context](mut app, 8080)
}

// This is how endpoints are defined in veb. This is the index route
pub fn (app &App) hello(mut ctx Context) veb.Result {
	return ctx.text('Hello Tasnager! The secret key is "${app.secret_key}"')
}

pub fn (mut app App) index() veb.Result {
	title := 'Tasnager'

	return $veb.html()
}
