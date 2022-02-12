all:
	stow .

clean:
	stow --delete .

check:
	stow --no .
