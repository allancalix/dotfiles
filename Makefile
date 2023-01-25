all:
	home-manager switch --flake ./nix#allancalix
	fd --maxdepth 1 . $HOME/.nix-profile/Applications --exec basename | xargs -I{} ln -s $(HOME)/.nix-profile/Applications/{} $(HOME)/Applications/{}

brew-up:
	brew bundle

clean:
	brew bundle cleanup -f
