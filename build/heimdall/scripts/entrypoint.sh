#!/bin/sh

# exit script on any error
set -e

# Set Heimdall Home Directory
HEIMDALLD_HOME=/root/.heimdalld

if [ ! -f "$HEIMDALLD_HOME/config/config.toml" ];
then
    echo "setting up initial configurations"
    NODENAME=${MONIKER:-nonamenode}
    heimdalld init
    
    cd $HEIMDALLD_HOME/config

    echo "removing autogenerated genesis file"
    rm genesis.json

    echo "downloading launch genesis file"
    wget https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/without-sentry/heimdall/config/genesis.json

    echo "overwriting toml config lines"
    sed -i "s/^moniker.*/moniker = \"$NODENAME\"/" config.toml
    sed -i "s/^cors_allowed_origins.*/cors_allowed_origins = [\"*\"]/" config.toml
    sed -i 's/^seeds.*/seeds = "f4f605d60b8ffaaf15240564e58a81103510631c@159.203.9.164:26656,4fb1bc820088764a564d4f66bba1963d47d82329@44.232.55.71:26656/"' config.toml
    sed -i "s/^bor_rpc_url.*/bor_rpc_url = \"http://bor:8540\"/" heimdall-config.toml
    sed -i "s/^eth_rpc_url.*/eth_rpc_url = \"http://fullnode.dappnode:8545\"/" heimdall-config.toml
fi