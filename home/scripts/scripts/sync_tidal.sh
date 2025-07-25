#!/usr/bin/env sh

# TODO
# Fix diffs (showing different songs each time)
# Fix tidal-dl (cant find streamURL)
PLAYLIST_ID="1efdc358-a72a-490a-89cd-8b61a18c5b3f"

DATAPATH="$XDG_DATA_HOME/sync_tidal"
DOWNLOADEDPATH="$DATAPATH/$PLAYLIST_ID/downloaded_songs.txt"
TODOWNLOADPATH="$DATAPATH/$PLAYLIST_ID/to_download_songs.txt"
INCOMINGDOWNLOADPATH="$DATAPATH/$PLAYLIST_ID/incoming_songs.txt"

rm $TODOWNLOADPATH $INCOMINGDOWNLOADPATH

mkdir "$DATAPATH/$PLAYLIST_ID" -p

# CLIENT_ID="LeN9l6zswWwmZsn8"
# CLIENT_SECRET="hPJ01wlCja9z65OGa4R1GaFcf1igu04KlJjvrnBPWHA="
# Limited input client info
CLIENT_ID="7m7Ap0JC9j1cOM3n"
CLIENT_SECRET="vRAdA108tlvkJpTsGZS8rGZ7xTlbJ0qaZ2K9saEzsgY"

URL="https://openapi.tidal.com/v2/playlists/"

LOGINRES=$(curl -s -X POST "https://auth.tidal.com/v1/oauth2/device_authorization" \
    -d "client_id=$CLIENT_ID" \
    -d "scope=r_usr" \
)
echo $LOGINRES

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



# TEST=$(curl -s -H "Authorization: Bearer $TOKEN" \
#      -H "X-Tidal-Token: $CLIENT_ID" \
#      "https://listen.tidal.com/v1/playlists/$PLAYLIST_ID/items?limit=100&offset=0&countryCode=GB")
# echo $TEST

# Get playlist song links
RES=$(echo $PLAYLIST | jq -r '.included.[].attributes.isrc')
NUMSONGS=$(echo $PLAYLIST | jq -r '.data.attributes.numberOfItems')

# Loop over tidal playlist increasing offset (limit is apparently 100) and return  once songs - newsongs = downlaoded move on


# Diff with database of songs
if [ ! -s $DOWNLOADEDPATH ]; then
    echo $RES | tr ' ' '\n' > $TODOWNLOADPATH
else
    touch $DOWNLOADEDPATH $TODOWNLOADPATH $INCOMINGDOWNLOADPATH
    echo $RES | tr ' ' '\n' > $INCOMINGDOWNLOADPATH
    DIFF=$(diff $DOWNLOADEDPATH $INCOMINGDOWNLOADPATH)
    # echo $DIFF | tr ' ' '\n' > $TODOWNLOADPATH
    echo $DIFF
    echo $(echo $DIFF | grep "<")
fi

# Download diff
if [ -s $TODOWNLOADPATH ]; then 
    # tidal-dl $TODOWNLOADPATH
    cat $TODOWNLOADPATH >> $DOWNLOADEDPATH
fi
