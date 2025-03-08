module main

import net.http
import veb
import encoding.base64
import json

@['/controller/users'; get]
pub fn (mut app App) controller_get_all_user() veb.Result {
	// token := app.get_cookie('token') or { '' }
	token := ctx.req.header.get_custom('token') or { '' }

	if !auth_verify(token) {
		ctx.res.set_status(http.status_from_int(401))
		return ctx.text('Not valid token')
	}

	response := app.service_get_all_user() or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('${err}')
	}
	return ctx.json(response)
}

@['/controller/user'; get]
pub fn (mut app App) controller_get_user() veb.Result {
	// token := app.get_cookie('token') or { '' }
	token := ctx.req.header.get_custom('token') or { '' }

	if !auth_verify(token) {
		ctx.res.set_status(http.status_from_int(401))
		return ctx.text('Not valid token')
	}

	jwt_payload_stringify := base64.url_decode_str(token.split('.')[1])

	jwt_payload := json.decode(JwtPayload, jwt_payload_stringify) or {
		ctx.res.set_status(http.status_from_int(501))
		return ctx.text('jwt decode error')
	}

	user_id := jwt_payload.sub

	response := app.service_get_user(user_id.int()) or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('${err}')
	}
	return ctx.json(response)
}

@['/controller/user/create'; post]
pub fn (mut app App) controller_create_user(username string, password string) veb.Result {
	if username == '' {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('username cannot be empty')
	}
	if password == '' {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('password cannot be empty')
	}
	app.service_add_user(username, password) or {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text('error: ${err}')
	}
	ctx.res.set_status(http.status_from_int(201))
	return ctx.text('User created successfully')
}
