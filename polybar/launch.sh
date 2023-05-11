#!/usr/bin/env sh

# Terminate running instances
polybar-msg cmd quit

# Wait for all instances to die
while pgrep -x polybar > /dev/null; do sleep 1; done

# Restart polybar (in the background)
polybar bottom 2>&1 | tee -a /tmp/polybar1.log & disown
