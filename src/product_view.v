module main

import net.http
import veb

@['/products'; get]
pub fn (mut app App) products(mut ctx Context) !veb.Result {
	token := ctx.get_cookie('token') or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('${err}')
	}

	user := get_user(token) or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('Failed to fetch data from the server. Error: ${err}')
	}

	return $veb.html()
}
