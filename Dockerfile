FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC

# ── Zależności systemowe ───────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    # narzędzia budowania
    git cmake build-essential \
    # OpenGL + Mesa software renderer (działa bez GPU)
    libgl1-mesa-dev libgl1-mesa-glx libglu1-mesa-dev mesa-utils \
    # SDL2 i rozszerzenia
    libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-gfx-dev \
    # audio (null backend w kontenerze)
    libopenal-dev \
    # Boost + SQLite3
    libboost-all-dev libsqlite3-dev \
    # wirtualny pulpit + VNC + noVNC
    xvfb x11vnc novnc websockify \
    && rm -rf /var/lib/apt/lists/*

# ── Klonuj fork vi3itor (tag 0.2, SDL2, Blunted2 wbudowany) ──────────────────
RUN git clone --depth=1 --branch 0.2 \
    https://github.com/vi3itor/GameplayFootball /opt/gpf

# ── Kompiluj ──────────────────────────────────────────────────────────────────
WORKDIR /opt/gpf
RUN mkdir build && \
    cp -r data build/ && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

# ── Skrypt startowy ───────────────────────────────────────────────────────────
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

ENV DISPLAY=:1 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    GALLIUM_DRIVER=llvmpipe \
    ALSOFT_DRIVERS=null

CMD ["/start.sh"]
