STOW=stow
STOWOPT=--ignore Makefile


all:
	$(STOW) $(STOWOPT) .

clean:
	$(STOW) $(STOWOPT) --delete .

check:
	$(STOW) $(STOWOPT) --no .
