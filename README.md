# spicemustflow

## Goals :

spicemustflow aims to simplyfy one-time sharing of *stuff* within your geeky LAN, it supports :

- URL sharing through nc(1)
- Any type of data sharing through a local bittorrent tracker started on-demand.

## Prerequisites : 

- Any unix-like system with `sh(1)` and `busybox(1)`
- `libowfat` & `opentracker` for the Bittorent tracker, see https://erdgeist.org/arts/software/opentracker/ for instructions (Kudos for the lovely opentracker software guys!)
- `transmission(1)` for the torrent file creation & seeding and remote access enabled in transmission
- ports 6969 & 8080 open on your local firewall

## Usage :

> Make sure to set the bare necessay variables in the script before starting it, namely : 

`opentracker_bin`

`tracker_ip`

and the transmission remote authentication (directly on the `transmission-remote --auth 'spicemustflow:spicemustflow' -a ./$filename.torrent` line since it doesn't play nice with variables apparently)

#### Sharing a link :

    ./spicemustflow.sh https://reddit.com

On the client, go to `http://sender_ip:8080`

#### Sharing a file :

> Transmission must be running before, it won't start automatically

    ./spicemustflow.sh some_large_file.mkv

If your transmission is well set, seeding will start right away.

On the client, go to `http://sender_ip:8080` and grab the torrent file, add the file to your torrent client.

#### Misc/disclaimer

This is just a proof-of-concept written in shell, while it works, it could also spawn dragons.