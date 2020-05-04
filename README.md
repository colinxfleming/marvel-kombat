# Marvel Kombat

Hello reviewers! Please see below for startup instructions, an explanation of the general flow I took, and 

## Assumptions

* You have ruby 2.7.1 installed
* You have node 12.16.3 installed (for webpack)

## Startup

Four steps:

* `RUBYOPT='-W:no-deprecated -W:no-experimental' # This makes ruby 2.7.1's deprecation warnings in gems quiet` 
* `bundle install && rails db:migrate`
* `rails s`
* Direct browser to `localhost:3000`

Secrets are in the secrets.yml.enc, so should be no additional configuration after that. No DB migrations to make.

## Testing

* `RUBYOPT='-W:no-deprecated -W:no-experimental' # This makes ruby 2.7.1's deprecation warnings in gems quiet` 
* `rails t`

## General flow

* Index loads a bare page
* After the page loads, make ajax calls to get characters
* When we've retrieved all characters we could apply the kombat logic to (e.g. that have descriptions that are long enough), populate the form
* User selects options and seed #s from the form and clicks submit
* KombatLogic concern makes API calls and calculates outcome
* Outcome displayed with ajax

## Notes

* I am not a fan of user input when we're doing lookups of confusing names, so I made an early design choice to put that on very tight guardrails. For the proof of concept this meant populating all characters that had descriptions. This avoids a whole lot of thorny design questions.
* Speaking of, there are a bunch of heroes that don't have descriptions (poor 3-D Man). So we aggressively filter heroes without descriptions or with descriptions under 9 words.
* To account for the big load time as we pull heroes from Marvel, the right way to go would be setting up caching of some kind (either by keeping a valid list of heroes and ids in db, or something similar). Long load time + as much ajax as possible is fine for a proof of concept like this, but that wouldn't make it to a prod system.
* The scary code is in the MarvelService and in KombatLogic, so that's where I did the bulk of the testing (and where I spent the bulk of the time programming). I wrote minimal tests in the interest of time.
* An obvious question is why to not include description in the pull, load that into everything, and not make additional API calls; this doesn't do a great job in that respect. I left it as is to encourage caching and then never quite set it up right.

## Spec

Per this spec:

* Tech design:
* The user will provide a SEED number between 1-9
* Retrieve the bio for each character and parse the “description” field
* Choose the WORD in each description at the position corresponding to the provided SEED
* The winner of the battle is the character whose WORD has the most characters EXCEPT if either character's WORD is a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
* Present the winning character to the user
* Handle any errors or edge cases and display the message in a user friendly manner
