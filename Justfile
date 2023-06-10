default:
	just --list

switch: render
	home-manager switch --flake .config/nix#allancalix
	fd --maxdepth 1 . $HOME/.nix-profile/Applications --exec basename | xargs -I{} ln -s $HOME/.nix-profile/Applications/{} $HOME/Applications/{}

update:
	nix flake update

lockbrew:
	brew bundle

clean:
	brew bundle cleanup -f

render:
	nickel export --format=toml -f ncl/starship.ncl > nix/starship/starship.toml

