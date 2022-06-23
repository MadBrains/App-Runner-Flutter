.PHONY: version doctor

PANA_SCRIPT=./tool/verify_pub_score.sh 100

EXAMPLE_PATH= example

FVM = fvm
FVM_FLUTTER = $(FVM) flutter
FVM_DART = $(FVM) dart


init:
	$(FVM) use 3.0.1 --force; $(FVM_DART) pub global activate pana;

version:
	$(FVM_FLUTTER) --version; $(FVM_DART) --version;

doctor:
	$(FVM_FLUTTER) doctor;

ifeq (bump, $(firstword $(MAKECMDGOALS)))
  runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(runargs):;@true)
endif
bump:
	./tool/bump-version.sh $(filter-out $@,$(MAKECMDGOALS))

build_runner:
	$(FVM_FLUTTER) pub run build_runner build --delete-conflicting-outputs;

pub_get:
	$(FVM_FLUTTER) packages get;

clean:
	$(FVM_FLUTTER) clean;

fix:
	$(FVM_FLUTTER) format .;

analyze:
	$(FVM_FLUTTER) analyze . --fatal-infos;

pana:
	$(PANA_SCRIPT);