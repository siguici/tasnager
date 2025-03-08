module main

import net.http
import veb

@['/controller/auth'; post]
pub fn (mut app App) controller_auth(mut ctx Context, username string, password string) veb.Result {
	response := app.service_auth(username, password) or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('error: ${err}')
	}

	return ctx.json(response)
}
