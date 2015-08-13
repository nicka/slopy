# Slopy (Slack/Spotify)

Control Spotify on OSX. Future plan is to intergrate with Slack.

## Usage

Start server

```
bundle exec rake start
```

Stop server

```
bundle exec rake stop
```

Restart server

```
bundle exec rake restart
```

## API routes

```
curl localhost:9292/api/start
curl localhost:9292/api/play
curl localhost:9292/api/play?url=spotify:user:xxxxxxx:playlist:123456
curl localhost:9292/api/pause
curl localhost:9292/api/next
curl localhost:9292/api/previous
curl localhost:9292/api/shuffle
curl localhost:9292/api/repeat
curl localhost:9292/api/volume?to=100
```
