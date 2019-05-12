# Autoclocker

<div align="center">
  <img width="215" src="https://i.imgur.com/LQxThih.gif" alt="autoclocker logo" />
</div>

**Autoclocker** is an automatic attendance clock in/out system

## Features

* Clocks in/out at specific times, every day
* Slack notifications (pings on error)
* Excludes weekends and holidays
* Runs as a background job
* Keeps any passwords/tokens in memory (requested at startup)

## Installation

*Tested in Jruby only*

```bash
rbenv install jruby-9.2.7.0
bundle
cp config.yml.example config.yml

```

Update `config.yml` with your own configuration.

## Usage

The advice is to use a tmux/screen session and leave the script running there on a VPS/server.

Less advisable, leave it running on your laptop (but the laptop will have to be turned on at clocking times)

```bash
bin/autoclocker
```

## TODO / Nice to have

* Tests
* Connect to google calendar
* Custom timings to clock in or out several times
* UI interface
* Daemonize process
* Encrypt secrets
* Make it API agnostic

## License

MIT
