# OTTER Website

Website for the Frankfurt University of Applied Science's FLOSS-Meetup "OTTER", which is to be hosted at https://fos3.org/.

## Running instructions

A running postgresql instance is required with username and password both being `postgres` (only for the time being, will be adaptable with environment variables in the future or can be changed in the file `config/dev.exs`). Then, run `mix deps.get` to install all relevant dependencies and `mix ecto.create` to generate the necessary database schema (running `mix ecto.migrate` may be necessary afterwards). To run the server, simple execute `mix phx.server` and the website will be reachable under `localhost:4000`.

### Note on package versions

If you are running Arch Linux, the `elixir` package should be sufficient. Debian-based distributions, on the other hand, are not as straightforward. A fairly recent version of Elixir and Erlang/OTP is required (which one specifically I'm not sure), which is not present in most Debian repositories. Fortunately, sufficiently recent versions of both packages can be found under https://www.erlang-solutions.com/downloads/. Recent testing has shown that installing Erlang/OTP version `27.3-1` and Elixir version `1.16.1_1` from the aforementioned website is recent enough to run the project.

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