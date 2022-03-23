sync:
	rsync -av \
		--exclude-from exclude.txt \
		. $(HOME)

switch:
	$(MAKE) sync
	home-manager switch
