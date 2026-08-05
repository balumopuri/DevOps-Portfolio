#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


Movies=("Jalsa" "GBS" "UGS" "BRO")

log "First movie: ${Movies[0]}"
log "Second movie: ${Movies[1]}"
log "Third movie: ${Movies[2]}"
log "Fourth movie: ${Movies[3]}"

log "All movies are: ${Movies[@]}"
