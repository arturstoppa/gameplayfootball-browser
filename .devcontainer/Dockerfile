FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC

# ── Zależności systemowe (oficjalne README google-research/football) ───────────
RUN apt-get update && apt-get install -y \
    git cmake build-essential \
    libgl1-mesa-dev libgl1-mesa-glx libglu1-mesa-dev mesa-utils \
    libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-gfx-dev \
    libboost-all-dev \
    python3 python3-pip python3-dev \
    xvfb x11vnc novnc websockify \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# ── pip install gfootball — kompiluje C++ automatycznie ───────────────────────
RUN python3 -m pip install --upgrade pip setuptools psutil wheel && \
    python3 -m pip install gfootball

COPY supervisord.conf /etc/supervisor/conf.d/game.conf

EXPOSE 6080

ENV DISPLAY=:1 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    GALLIUM_DRIVER=llvmpipe \
    ALSOFT_DRIVERS=null

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/game.conf"]
