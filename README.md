# Fakebook


## What this project is

Fakebook is a minimal social network prototype built with Ruby on Rails. It
implements core social features so you can experiment with account
authentication, user profiles, posting content with images, following other
users, liking and commenting on posts, and basic pagination.

Key features

- User accounts and authentication (Devise, with Google & GitHub OmniAuth)
- User profiles with avatar uploads (Active Storage)
- Create posts with optional image attachments (multiple images supported)
- Like and comment on posts
- Follow / unfollow users, view followers and following lists
- Pagination (Kaminari)
- Turbo/Stimulus & Importmap-ready frontend (no webpack)

## Tech stack

- Ruby on Rails ~8.0 (see `Gemfile`) with PostgreSQL (`pg`)
- Authentication: `devise` and `omniauth` providers
- Active Storage for file uploads
- Frontend: `importmap-rails`, `turbo-rails`, `stimulus-rails` (no webpack)
- CSS build: `sass` + `postcss` via npm scripts in `package.json`

## Environment / configuration

This project expects environment variables for third-party OAuth providers if
you want to enable sign-in via Google/GitHub. Example (recommended to use
`.env` and `dotenv-rails` in development):

- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GITHUB_KEY`
- `GITHUB_SECRET`

Other configuration (database, Active Storage service) follows standard Rails
conventions in `config/database.yml` and `config/storage.yml`.

## Setup (development)

1. Install Ruby gems

```bash
bundle install
```

2. Create and migrate the database

```bash
rails db:create db:migrate db:seed
```

3. Start the app

```bash
rails server
```

## Development notes

- Uploads: Active Storage is configured in `config/storage.yml`. In local
	development the default disk service is used.
- Authentication: Devise is configured and OmniAuth providers (Google/GitHub)
	are enabled — configure provider keys as environment variables as shown above.
