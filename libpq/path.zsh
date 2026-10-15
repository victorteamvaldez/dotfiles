# libpq is keg-only: Homebrew does not link psql into /opt/homebrew/bin.
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
