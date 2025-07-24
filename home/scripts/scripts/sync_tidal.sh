#!/usr/bin/env sh

# TODO
# Fix diffs (showing different songs each time)
# Fix tidal-dl (cant find streamURL)

PLAYLIST_ID="1efdc358-a72a-490a-89cd-8b61a18c5b3f"
mkdir "$DATAPATH/$PLAYLIST_ID" -p

DATAPATH="$XDG_DATA_HOME/sync_tidal"
DOWNLOADEDPATH="$DATAPATH/$PLAYLIST_ID/downloaded_songs.txt"
TODOWNLOADPATH="$DATAPATH/$PLAYLIST_ID/to_download_songs.txt"
INCOMINGDOWNLOADPATH="$DATAPATH/$PLAYLIST_ID/incoming_songs.txt"


CLIENT_ID="LeN9l6zswWwmZsn8"
CLIENT_SECRET="hPJ01wlCja9z65OGa4R1GaFcf1igu04KlJjvrnBPWHA="

URL="https://openapi.tidal.com/v2/playlists/"


TOKEN=$(curl -s -X POST "https://auth.tidal.com/v1/oauth2/token" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  -d "scope=rw" \
  | jq -r '.access_token')


# Get list of songs in playlist
PLAYLIST=$(curl -X "GET" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/vnd.tidal.v1+json" \
    "$URL$PLAYLIST_ID?include=items")

# Get playlist song links
LINKS=$(echo $PLAYLIST | jq -r '.included.[0].attributes.isrc')
echo $LINKS


# Diff with database of songs
if [ ! -s $DOWNLOADEDPATH ]; then
    echo $LINKS | tr ' ' '\n' > $TODOWNLOADPATH
else
    touch $DOWNLOADEDPATH $TODOWNLOADPATH $INCOMINGDOWNLOADPATH
    echo $LINKS | tr ' ' '\n' > $INCOMINGDOWNLOADPATH
    DIFF=$(diff $DOWNLOADEDPATH $INCOMINGDOWNLOADPATH)
    # echo $DIFF
    # echo $DIFF | tr ' ' '\n' > $TODOWNLOADPATH
fi

# Download diff
# tidal-dl $TODOWNLOADPATH
cat $TODOWNLOADPATH >> $DOWNLOADEDPATH
