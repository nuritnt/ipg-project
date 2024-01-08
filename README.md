# ipg-project

This project the module ipg for my computer science bachelor at FHNW.
It sums all the files and the documentation I have used for my final presentation.

## Instructions
`./check_documents.sh`

## Beschreibung
Erstellen eines GUI's, welches ein Bash Script auslöst. Es soll analyiseren, ob ein Input mit Array alle erfolgreich auf dem Server sind. Erst wird die Quersumme mit md5 Hash analysiert, wenn diese abweicht, wird ein Schlaufe durchlaufen, welches die fehlenden Dateinamen raussucht und zurück gibt.

## Präsentation
Mittels `ssh -p 2222 normalo@localhost` auf lokalem Gerät einloggen (UTM läuft bereits)
Konzept erklären
ls -> files zeigen
./check_documents.sh
nano check_documents.sh
nano check_missing_files.sh
nano check_documents.log
Lösung: im IST.txt fehlen 3 Files: DSC06450.jpeg, DSC06670.jpeg, DSC06830.jpeg

## Dokumentation (history printout)
Dialog war schon installiert, aber wenn man es neu installieren möchte, kann man das mit `sudo apt install dialog`
```
touch check_documents.sh
nano check_documents.sh
curl -O https://raw.githubusercontent.com/nuritnt/missing-files-bash-checker/main/check_missing_files.sh
chmod +x check_missing_files.sh
wget https://raw.githubusercontent.com/nuritnt/missing-files-bash-checker/main/check_missing_files.sh
chmod +x check_missing_files.sh (change mod, mach es executable)
./check_documents.sh
chmod +x check_documents.sh
./check_documents.sh
nano check_documents.sh
touch IST.txt
touch SOLL.txt
nano IST.txt
nano SOLL.txt
```

## Erweiterungsmöglichkeiten
- Ein Monitoring einrichten, dass dies immer ausgeführt wird, wenn grosse Mengen an Files hochgeladen werden
- Check_missing_files.sh Skript erweitern, sodass tatsächlich Files auf dem Server verglichen werden
- SOLL.txt vs IST.txt files dynamisch oder mit einem Input Feld hinterlegen.
- Umlaute (ÜÄÖ) Support im Skript einrichten


## Logging Erklärung
`exec > > (tee -a check_documents.log)`
exec wird verwendet, um die Umleitung der Standardausgabe (stdout) zu ändern.
>(tee -a check_documents.log) ist ein Prozess-Substitution-Konstrukt. Es erstellt eine Pipe, schreibt den Ausgabestrom von exec in die Pipe und übergibt ihn dann an tee.
tee ist ein Befehl, der dazu dient, den Input sowohl auf die Standardausgabe als auch in eine Datei zu schreiben.
-a gibt an, dass die Ausgabe an das Ende der Datei angehängt werden soll (append).
check_documents.log ist der Name der Log-Datei.

Insgesamt bewirkt diese Zeile, dass alles, was normalerweise auf stdout geschrieben wird, sowohl auf die Konsole als auch in die angegebene Log-Datei geschrieben wird.

`exec 2>&1``
Diese Zeile ändert die Umleitung für den Standardfehler (stderr).
2>: gibt an, dass es sich um eine Umleitung für den Standardfehler (stderr) handelt. In der Bash ist 2 die Nummer, die stderr repräsentiert.
&1: Hier wird stderr (2) auf den gleichen Ort umgeleitet wie stdout (1). Das & bedeutet, dass es sich um einen Dateideskriptor handelt, nicht um eine Datei selbst. In diesem Fall wird stderr auf denselben Ort umgeleitet wie stdout.
Da wir zuvor die Standardausgabe bereits auf die Konsole und in die Log-Datei umgeleitet haben, wird der Standardfehler ebenfalls an diese Orte umgeleitet.

Zusammengefasst bewirken diese beiden Zeilen, dass sowohl die Standardausgabe als auch der Standardfehler sowohl auf die Konsole als auch in die angegebene Log-Datei geschrieben werden. Das ist nützlich, um alle Ausgaben und Fehlermeldungen in einer Log-Datei aufzuzeichnen, was besonders praktisch ist, wenn das Skript als Hintergrundprozess ausgeführt.

Ausserdem wurde dieses Logging gewählt, damit es auf verschiedenen Betriebssystemen unterstützt wird.
