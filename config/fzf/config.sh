#!/bin/sh

FZF_BINDINGS=$(
	tr -d '\n' <<-END
	--bind=
	tab:toggle+down,
	P:toggle-preview,
	J:down,
	K:up,
	G:clear-query+first,
	btab:up,
	A:toggle-all
	END
)

FZF_THEME=$(
	tr -d '\n' <<-END
	--color=
	prompt:#AEC694,
	pointer:#8FAAC9,
	marker:red,
	header:#8FAAC9,
	query:regular
	END
)

export FZF_THEME_DARK=$(
	tr -d '\n' <<-END
	--color=
	border:#444B5D,
	fg:#d8dee9,
	fg+:#d8dee9,
	bg+:#444B5D,
	gutter:#2e3440
	END
)

export FZF_THEME_LIGHT=$(
	tr -d '\n' <<-END
	--color=
	border:#d8dee9,
	fg:#2e3440,
	fg+:#2e3440,
	bg+:#d8dee9,
	gutter:#ffffff
	END
)

export FZF_DEFAULT_OPTS=$(
	tr '\n' ' ' <<-END
	$FZF_BINDINGS
	$FZF_THEME
	--multi
	--reverse
	--no-info
	--preview-window=65%,hidden,border-sharp
	END
)
