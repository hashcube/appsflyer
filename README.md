# AppsFlyer plugin for GameClosure Devkit

Please get the AppsFlyer dev key from the dashboard.

## Usage

Include this module as a dependency in your game's manifest file.

```
"dependencies": {
    "appsflyer": "https://github.com/hashcube/appsflyer.git#master"
}
```

Then add `appsFlyerDevKey` to iOS or android section.

```
"ios": {
    "appsFlyerDevKey": "xxx"
},
"android": {
    "appsFlyerDevKey": "xxx"
}
```

For amazon builds, switch to `amazon` branch of this repo.
