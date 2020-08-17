FROM yguyot/dem-server:esyrunbase

COPY --chown=opam:opam . /home/opam

CMD esy --verbose build && esy --verbose start
