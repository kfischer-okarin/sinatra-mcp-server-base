# sinatra-mcp-server-base

## Install dependencies

```sh
bundle install
```

## Run the dev server

```sh
bundle exec rake dev
```

### Hot reloading

Sinatra does not have built-in hot reloading. You can use a tool like [entr](https://github.com/eradman/entr) to automatically restart the server when files change.

For example, to reload the server when any Ruby file changes:

```sh
ls *.rb | entr -r bundle exec rake dev
```
