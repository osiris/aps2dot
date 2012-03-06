black:
	./aps2dot >aps.dot;neato -Tpng aps.dot >aps.png
white:
	./aps2dot -b white >aps.dot;neato -Tpng aps.dot >aps.png
blue:
	./aps2dot -o blue >aps.dot;neato -Tpng aps.dot >aps.png
ellipse:
	./aps2dot -n ellipse >aps.dot;neato -Tpng aps.dot >aps.png
font:
	./aps2dot -f FreeMono >aps.dot;neato -Tpng aps.dot >aps.png
solid:
	./aps2dot -y solid >aps.dot;neato -Tpng aps.dot >aps.png
