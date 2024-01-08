#!/bin/bash

# Ueberpruefen, ob zwei Dateipfade als Argumente angegeben wurden
# $# repraesentiert die Anzahl der Argumente
# -ne -> not equals
# Die Variable $0 gibt den Namen des aktuellen Shell-Skripts oder der ausfuehrbaren Datei zurueck.
if [ "$#" -ne 2 ]; then
  echo "Verwendung: $0 IST-Datei SOLL-Datei"
  
  # Beende das Skript mit einem Fehlercode 1, um anzuzeigen, dass ein Fehler aufgetreten ist
  exit 1
fi

# Die Dateipfade basierend auf den uebergebenen Argumenten festlegen
ist_datei="$1"
soll_datei="$2"

# Ueberpruefen, ob die IST-Datei existiert
# -f fuer Files
if [ ! -f "$ist_datei" ]; then
    echo "Die IST-Datei $ist_datei wurde nicht gefunden."
    
    # Beende das Skript mit einem Fehlercode 1
    exit 1
fi

# Ueberpruefen, ob die SOLL-Datei existiert
if [ ! -f "$soll_datei" ]; then
    echo "Die SOLL-Datei $soll_datei wurde nicht gefunden."
    
    # Beende das Skript mit einem Fehlercode 1
    exit 1
fi

# Liste zum Speichern der fehlenden Dateien
# Die =()-Syntax in Bash wird verwendet, um ein leeres Array zu initialisieren.
fehlende_dateien=()

# Durchlaufe jede Datei in der SOLL-Datei und pruefe, ob sie in der IST-Datei fehlt
while IFS= read -r datei; do
    # IFS ist das "Internal Field Separator" und wird auf den Wert " " (Leerzeichen) gesetzt
    # read -r wird verwendet, um Backslashes nicht als Escape-Zeichen zu interpretieren
    # Dadurch wird sichergestellt, dass der gesamte Dateiname als eine Zeichenkette betrachtet wird
    # und nicht in Teile zerlegt wird, wenn Leerzeichen vorhanden sind
    
    # Ueberpruefen, ob die Datei fehlt
    # Wenn grep die Datei $datei in der Datei $ist_datei nicht findet, gibt es keinen sichtbaren Output auf der Konsole (dank -q).
    # Wird nur ausgefuehrt, wenn IST.txt nicht gefunden wird.
    # -q fuer quet oder silent 
    if ! grep -q "$datei" "$ist_datei"; then
        echo "Die Datei $datei fehlt in IST.txt."
        
        # Hinzufuegen der fehlenden Datei zur Liste der fehlenden Dateien
	# FUegt dem leeren Array "fehlende_dateien" mittels +=() hinzu
        fehlende_dateien+=("$datei")
    fi
done < "$soll_datei"
# < wird in Bash fuer eine Eingabeumleitung verwendet
# Datei, deren Pfad in der Variable $soll_datei gespeichert ist, als Eingabestrom für die Schleife verwendet wird.

# Ausgabe der Anzahl der fehlenden Dateien
anzahl_fehlender_dateien=${#fehlende_dateien[@]}

# Ausgabe der Anzahl der fehlenden Dateien und der Liste der fehlenden Dateien in IST.txt
# -gt steht fuer greater than
# Wenn fehlende Dateien vorhanden sind (Anzahl > 0), werden Informationen zu diesen in IST.txt ausgegeben.
echo "Anzahl der fehlenden Dateien in IST.txt: $anzahl_fehlender_dateien"
if [ "$anzahl_fehlender_dateien" -gt 0 ]; then
    echo "Fehlende Dateien in IST.txt: ${fehlende_dateien[@]}"
fi
