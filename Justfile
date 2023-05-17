default:
	just --list

switch:
	home-manager switch --flake .config/nix#allancalix
	fd --maxdepth 1 . $HOME/.nix-profile/Applications --exec basename | xargs -I{} ln -s $HOME/.nix-profile/Applications/{} $HOME/Applications/{}

update:
	nix flake update

lockbrew:
	brew bundle

clean:
	brew bundle cleanup -f