default:
	just --list

update: bumpdeps switch

switch: render clean
	brew bundle install
	home-manager switch --flake flake.nix#allancalix

bumpdeps:
	brew bundle
	nix flake update

clean:
	brew bundle cleanup -f

render:
	nickel export --format=toml -f ncl/starship.ncl > nix/starship/starship.toml

