all:
	home-manager switch --flake .config/nixpkgs#allancalix

brew-up:
	brew bundle

clean:
	brew bundle cleanup -f
