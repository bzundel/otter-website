# OTTER Website

Website for the Frankfurt University of Applied Science's FLOSS-Meetup "OTTER", which is to be hosted at https://fos3.org/.

## Running instructions
### Manual
A running postgresql instance is required with username and password both being `postgres` (only for the time being, will be adaptable with environment variables in the future or can be changed in the file `config/dev.exs`). Then, run `mix deps.get` to install all relevant dependencies and `mix ecto.create` to create the database, followed by `mix ecto.migrate` to generate the tables. Running the seeding script with `mix run priv/repo/seeds.exs` will create an invitation key in the database with the value `INITIAL_ADMIN_KEY` so you can create an account (which will save to from having to manually create one in the database). To run the server, simple execute `mix phx.server` and the website will be reachable under `localhost:4000`.

To enable publishing toots to Mastodon from the admin panel, one must also set the environment variables `MASTODON_BASE_URL` and `MASTODON_ACCESS_TOKEN` with the instance URL and application access token, respectively.

#### Note on package versions
If you are running Arch Linux, the `elixir` package should be sufficient. Debian-based distributions, on the other hand, are not as straightforward. A fairly recent version of Elixir and Erlang/OTP is required (which one specifically I'm not sure), which is not present in most Debian repositories. Fortunately, sufficiently recent versions of both packages can be found under https://www.erlang-solutions.com/downloads/. Recent testing has shown that installing Erlang/OTP version `27.3-1` and Elixir version `1.16.1_1` from the aforementioned website is recent enough to run the project.

### Docker
This project has support for deployment with docker. In a development context, running `docker-compose up --build` should suffice to start the container. For production, make sure you first set all required environment variables since they are responsible for securing the application. **A warning will not be thrown if an environment variable is missing; development defaults will be used for missing values**.

## Adding posts
To add posts, simply add markdown files into the directory `priv/posts`. The individual filenames **must** be in the format `YEAR_MONTH_DAY_HOUR_MINUTE_SOME-UNIQUE-IDENTIFIER.md` (please excuse this for now, a refactoring is planned) or they won't be read (or worse?) and have a header containing some metadata of the following format:

```markdown
%{
  title: "Some title of your choosing",
  author: "Optimally your name",
  tags: ~w(some tags relevant to the post seperated by spaces),
  description: "A description that summarizes the content of the post"
}
---
# Here begins the actual post content
After the three dashes `---` above you are free to write as much markdown as you want.
```
