import { qwikVite } from "@builder.io/qwik/optimizer";
import {
	defineConfig,
	type ConfigEnv,
	ServerOptions,
	loadEnv,
	type UserConfig,
} from "vite";

function defaultServerOptions(opts: {
	host: string | undefined;
	port: number | undefined;
	base: string | undefined;
	root: string | undefined;
}): ServerOptions {
	return {
		...defaultConfig(opts),
		hmr: {
			host: opts.host,
			port: opts.port,
		},
	};
}

function defaultConfig(opts: {
	host: string | undefined;
	port: number | undefined;
	base: string | undefined;
	root: string | undefined;
}): UserConfig {
	return {
		plugins: [
			qwikVite({
				csr: true,
			}),
		],
		preview: {
			headers: {
				"Cache-Control": "public, max-age=600",
			},
		},
		resolve: {
			alias: {
				"@/": "/src/",
			},
		},
		...opts,
	};
}

// https://vite.dev/config/
export default defineConfig(({ command, mode }: ConfigEnv): UserConfig => {
	const env = loadEnv(mode, process.cwd(), "");
	const buildDirectory = env.VITE_CONFIG_BUILD_DIRECTORY ?? "static";
	const host = env.VITE_CONFIG_SERVER_HOST ?? "localhost";
	const base =
		(env.VITE_CONFIG_SERVER_BASE ?? "/") +
		(command === "build" ? buildDirectory : "");
	const port = Number(env.VITE_CONFIG_SERVER_PORT ?? 4000);
	const root = env.VITE_CONFIG_SERVER_ROOT;

	if (command === "serve") {
		return {
			server: defaultServerOptions({ host, port, base, root }),
			...defaultConfig({ host, port, base, root }),
		};
	}

	return defaultConfig({ host, port, base, root });
});
