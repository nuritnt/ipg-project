#!/bin/bash
# Shebang: Skript soll  mit dem Bash-Interpreter ausgefuehrt werden soll

# Logging aktivieren
# Die naechsten beiden Zeilen leiten sowohl Standardausgabe (stdout) als auch
# Standardfehler (stderr) in eine Log-Datei (check_documents.log) und auf die Konsole (tee) um.
exec > >(tee -a check_documents.log)
exec 2>&1

# Statisch hinterlegte Pfade zu IST- und Soll-Dokumenten
ist_dokument="IST.txt"
soll_dokument="SOLL.txt"

# Ueberpruefen, ob die Dateien existieren
# -f fuer files, -d fuer directories
# dialog --backtitle "Backtitle" --title "Title" --yesno "Text" height width
if [ ! -f "$ist_dokument" ] || [ ! -f "$soll_dokument" ]; then
  # Dialog anzeigen, wenn eine oder beide Dateien nicht existieren
  dialog --backtitle "Dokumentenpruefung" --title "Fehler" \
  --yesno "Eine oder beide der angegebenen Dokumente existieren nicht. Moechten Sie den Vorgang abbrechen?" 8 60

 # $? fuer den Exit-Code des zuletzt ausgefuehrten Befehls oder Skripts.
 # 0 = Befehl erfolgreich abgeschlossen
 # 1 = Fehler
 # ;; Case Trenner
  response=$?
  case $response in
    0) echo "Abgebrochen.";;	# Benutzer hat Abbrechen ausgewaehlt
    1) exit 1;;                 # Benutzer hat Weiter ausgewaehlt, Skript mit Fehlercode beenden
  esac
fi

# Benachrichtigung vor dem eigentlichen Vergleich
dialog --backtitle "Dokumentenpruefung" --title "Info" \
--msgbox "Dokumente gefunden. Ueberpruefung wird gestartet." 8 60

# Ueberpruefung der beiden Dokumenten mit md5 Hash
# =$() -> "Command Substitution" in Bash.
# Erlaubt die Ausfuehrung eines Befehls innerhalb eines anderen Befehls
# und setzt das Ergebnis des inneren Befehls an dieser Stelle ein.
# awk command awk is mostly used for pattern scanning and processing.
ist_md5=$(md5sum "$ist_dokument" | awk '{print $1}')
soll_md5=$(md5sum "$soll_dokument" | awk '{print $1}')

# Dokumente sind gleich
if [ "$ist_md5" == "$soll_md5" ]; then
  # Dialog anzeigen, wenn die MD5-Summen uebereinstimmen (Dokumente sind gleich)
  dialog --backtitle "Dokumentenpruefung" --title "Ergebnis" \
  --msgbox "Die Dokumente sind gleich. Es gibt nichts weiter zu tun." 8 60
else #Dokumente sind ungleich
  dialog --backtitle "Dokumentenpruefung" --title "Ergebnis" \
  --yesno "Die Dokumente unterscheiden sich. Moechten Sie die fehlenden Dateien anzeigen?" 8 60

  # bash script mit missing files checker laufen lassen
  response=$?
  case $response in
    0) ./check_missing_files.sh "$ist_dokument" "$soll_dokument";; # Skript ausfuehren
    1) echo "Abgebrochen.";;					   # Benutzer hat Abbrechen ausgewaehlt
  esac
fi

