default:
	just --list

switch: render
	home-manager switch --flake flake.nix#allancalix
	./scripts/link-gui.sh

update:
	nix flake update

lockbrew:
	brew bundle

clean:
	brew bundle cleanup -f

render:
	nickel export --format=toml -f ncl/starship.ncl > nix/starship/starship.toml

