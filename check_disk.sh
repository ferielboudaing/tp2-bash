#!/bin/bash
# Alerte si l'espace disque depasse un seuil (80% par defaut)

SEUIL=${1:-80}
UTILISATION=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : disque utilise a ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 1
fi

echo "OK : disque utilise a ${UTILISATION}% (seuil : ${SEUIL}%)"
exit 0 
