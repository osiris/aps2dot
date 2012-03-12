Draw AccessPoints
=================

Usage
-----

::

    ./aps2dot >aps.dot

    -m     show MAC Address
    -s     show SSID (default=ON)
    -b     background color (default=black)
    -c     closed color (default=red)
    -o     open color (default=limegreen)
    -f     font name (default=inconsolata)     
    -n     node shape (default=plaintext)
    -y     edge style (default=invis)
    -l     CC License (default=ccbysa)

    -?, --help   this Help


Example
-------

::

    ./aps2dot >aps.dot;neato -Tpng aps.dot >aps.png

