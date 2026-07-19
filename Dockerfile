FROM nixos/nix

RUN nix-channel --update
RUN nix-build -A pythonFull '<nixpkgs>'

WORKDIR /build

COPY . .

RUN nix-store --realise $(nix-instantiate shell.nix --drv-only) --include-outputs

CMD ["nix-shell", "--pure", "--run", "make -L -j\$((\$(nproc) - 2))"]