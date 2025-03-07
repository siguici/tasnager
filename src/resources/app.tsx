import { component$, useSignal } from "@builder.io/qwik";

import qwikLogo from "./qwik.svg";
import viteLogo from "./vite.svg";
import "./app.css";

export const App = component$(() => {
	const count = useSignal(0);

	return (
		<>
			<div>
				<a href="https://vite.dev" target="_blank" rel="noreferrer">
					<img src={viteLogo} class="logo" alt="Vite logo" />
				</a>
				<a href="https://qwik.dev" target="_blank" rel="noreferrer">
					<img src={qwikLogo} class="logo qwik" alt="Qwik logo" />
				</a>
			</div>
			<h1>Vite + Qwik</h1>
			<div class="card">
				<button type="button" onClick$={() => count.value++}>
					count is {count.value}
				</button>
			</div>
			<p class="read-the-docs">
				Click on the Vite and Qwik logos to learn more
			</p>
		</>
	);
});
