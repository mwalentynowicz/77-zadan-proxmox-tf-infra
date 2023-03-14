#!/usr/bin/env bash

#Skrypt przygotowujacy maszyne lokalna do uruchomienia terraforma
#v.0.1 - wersja nieinteraktywna


#kopiowanie szablonu - bez parametryzacji to troche puste dzialanie :)
cp ../credentials.tmp ../credentials.tf
echo "Przed uruchomieniem terraforma podmien dane logowania w pliku credentials.tf!"

#
echo "Podmien wartosc var.clusteraddress w pliku ../terraform.tf"

#
echo "Zajrzyj do ../variable.tf w celu sprawdzenia adresacji IP VMek"

#
echo "Zaloguj sie na serwer Proxmox w celu wykonania skryptow create_ubuntu_template.sh albo create_debian_tempalte.sh w zaleznosci, ktora wersje chcesz miec. W PDFie wymienione jest ubuntu :)"

#automatyczne generowanie kluczy na potrzeby proxmoxa
mkdir ../ssh_keys
ssh-keygen -q -N "" -t ed25519 -f ../ssh_keys/fingerprint_ed25519_key
ssh-keygen -q -N "" -t rsa -f ../ssh_keys/id_rsa
ssh-keygen -q -N "" -t rsa -f ../ssh_keys/fingerprint_rsa
cd ..
echo "Wygenerowano klucze potrzebne dla terraforma."