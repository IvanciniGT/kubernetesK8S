#!/bin/bash

sudo swapoff -a 
sudo sed -i 's/\/swap/#\/swap/' /etc/fstab

SWAP_ACTUAL=$(free | grep Swap)
if [[ "$SWAP_ACTUAL" =~ [1-9] ]]
then
    echo ERROR. No se ha podido desactivar la swap
else
    echo INFO. Swap desactivada correctamente
fi
