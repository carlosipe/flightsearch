
TESTS=$(shell ls tests/**/*.rb)

default: help

c: console
t: test

console:
	@irb -r ./app.rb -r ./cli.rb

console_test:
	@irb -r ./tests/helper.rb -r ./cli.rb

help:
	@cat ./docs/help

install: init update migrate

init:
	@cp -n .env.example .env
	@gem install dep

test:
	ruby -W1 .gs/bin/cutest $(TESTS)

migrate:
	@ruby -r ./app.rb -e 'Sequel.extension :migration; Sequel::Migrator.run(DB, "db/migrations")'

migrate_testing:
	@ruby -r ./tests/helper.rb -e 'Sequel.extension :migration; Sequel::Migrator.run(DB, "db/migrations")'

tdd:
	watch -n0 ruby -W1 .gs/bin/cutest $(TESTS)

.PHONY: c t console test help install init update migrate migrate_testing console_test tdd