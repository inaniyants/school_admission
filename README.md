
# Law Schools Admission Data

This app lets users search for the median of the different test scores in various law schools, as well as to find the best matches according to their scores.

## Local development

### Prerequisites

* elixir `1.12+` and `(compiled with Erlang/OTP 24+)` (tested on `Elixir 1.14.3 (compiled with Erlang/OTP 25)`)

* docker desktop

### To start the application locally:

* run `docker-compose up -d` to initialise Postgres container

* Run `mix setup` to install and setup dependencies

* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Todo:
- [x] mockup thoughts on UI\UX (see )  
- [x] Implement base `Score` app requirements
	- [x] Allow the user to select a school.
	- [x] Output a grammatically correct sentence about the median (50th percentile) LSAT score
	- [x] Reflect the data visually in at least one way: for example, through coloring, sizing, motion, or a graphic element
	- [x] Use Elixir and Phoenix
	- [x] Add Readme that explains how to run the project locally
- [x] Implement extra `Score` app requirements 
	- [x] add GPA scores
	- [ ] add GRE scores
	- [x] add Chart with percentiles visualization
	- [ ] add `years` multiple select to compare specific years
- [x] Implement the `Match` app
	- [x] normalize CSV data into Ecto schemas ( simplifies match app )
	- [x] match by LSAT score
	- [x] match by GPA score
	- [ ] match by GRE score
	- [x] add school rank as match criteria (sorting)
	- [ ] add `load more` to load more matches
- [x] Add basic mobile optimizations
- [ ] Add `Dockerfile` to build the app into the container
- [ ] Add app to `docker-compose.yml` to simplify local env setup
- [ ] Prepare prod env and deploy the App to fly.io or another hosting for a demo
- [ ] add dark theme support
- [x] use the latest elixir ecosystem ( phoenix, erlang, OTP, deps, postgres )
	- [ ] refactor backend code to match the latest best practices
	- [ ] refactor frontend code to use a consistent ecosystem ( React.js, Hotwired Stimulus )
- [ ] cover with tests
