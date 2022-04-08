FROM steamcmd/steamcmd:ubuntu-20 AS install

RUN steamcmd \
        +force_install_dir "/gmodds" \
        +login anonymous \
        +app_update 4020 -validate \
        +quit

RUN apt update -y && \
    apt install -y \
        unzip \
        wget \
        libncurses5:i386

RUN wget -q -O /tmp/ulib.zip https://ulyssesmod.net/archive/ULib/ulib-v2_63.zip && \
    wget -q -O /tmp/ulx.zip https://ulyssesmod.net/archive/ulx/ulx-v3_73.zip && \
    wget -q -O /tmp/prophunt.zip https://github.com/prop-hunt-enhanced/prop-hunt-enhanced/archive/refs/heads/master.zip && \
    unzip -q /tmp/ulib.zip -d /gmodds/garrysmod/addons/ulib && \
    unzip -q /tmp/ulx.zip -d /gmodds/garrysmod/addons/ulx && \
    unzip -q /tmp/prophunt.zip -d /gmodds/garrysmod/addons && \
    cp -r /gmodds/garrysmod/addons/prop-hunt-enhanced-master/gamemodes/* /gmodds/garrysmod/gamemodes

FROM steamcmd/steamcmd:ubuntu-20

COPY --from=install /usr/lib/i386-linux-gnu /usr/lib/i386-linux-gnu
COPY --from=install /gmodds /gmodds

WORKDIR /gmodds

EXPOSE 27015/udp
VOLUME [ "/gmodds/garrysmod/maps" ]

ENTRYPOINT ["./srcds_run", "-game garrysmod", "-console", "-norestart", "-strictportbind"]
CMD ["-port 27015", "-tickrate 32", "-maxplayers 16", "-insecure", "+gamemode prop_hunt", "+map ph_office"]