default:
	just --list

update: bumpdeps switch
	brew bundle install

switch: render
	home-manager switch --flake flake.nix#allancalix

bumpdeps:
	brew bundle
	nix flake update

clean:
	brew bundle cleanup -f

render:
	nickel export --format=toml -o nix/starship/starship.toml ncl/starship.ncl

