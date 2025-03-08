import veb

// Our context struct must embed `veb.Context`!
pub struct Context {
	veb.Context
pub mut:
	// In the context struct we store data that could be different
	// for each request. Like a User struct or a session id
	user       User
	session_id string
}

pub struct App {
	veb.StaticHandler
pub:
	// In the app struct we store data that should be accessible by all endpoints.
	// For example, a database or configuration values.
	secret_key string
}

pub fn (mut ctx Context) not_found() veb.Result {
	// set HTTP status 404
	ctx.res.set_status(.not_found)
	return ctx.html('<h1>Page not found!</h1>')
}

pub fn (app App) before_request(ctx Context) {
	println('[veb] before_request: ${ctx.req.method} ${ctx.req.url}')
}
