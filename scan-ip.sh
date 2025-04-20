#!/bin/bash

# ===== Funciones =====

puertos() {
    read -p "Ingresa la IP: " ip
    echo "[*] Escaneando puertos en $ip..."
    sudo nmap -p- "$ip"
}

equipos() {
    read -p "Ingresa la IP o red (ej. 192.168.0.0/24): " red
    echo "[*] Buscando equipos activos en $red..."
    sudo nmap -sn "$red"
}

sistema_operativo() {
    read -p "Ingresa la IP: " ip
    echo "[*] Detectando sistema operativo en $ip..."
    resultado=$(sudo nmap -O "$ip")
    echo "$resultado"

    so_detectado=$(echo "$resultado" | grep -iE "windows|linux|unix|ios|mac")
    if [ -n "$so_detectado" ]; then
        echo "[+] Sistema Operativo detectado: $so_detectado"
    else
        echo "[!] No se pudo identificar el sistema operativo."
    fi
}

dos_simulado() {
    read -p "Ingresa la IP objetivo: " ip
    echo "[*] Iniciando envío de paquetes ICMP a $ip..."
    while true; do
        ping -c 10 "$ip"
        sleep 1
    done
}

ver_ip() {
    read -p "Ingresa un dominio (ej. google.com): " dominio
    echo "IP Pública: $(curl -s ifconfig.me)"
    echo "IP del dominio $dominio: $(dig +short "$dominio")"
}

# ===== Menú =====

menu() {
    echo ""
    echo "==== MENÚ DE RED ===="
    echo "1) Escanear puertos"
    echo "2) Escanear equipos"
    echo "3) Verificar sistema operativo"
    echo "4) Simular DoS (10 ICMP por ronda)"
    echo "5) Verificar IP"
    echo "6) Salir"
    echo "======================"
}

# ===== Bucle principal =====

while true; do
    clear
    menu
    read -p "Elige una opción [1-6]: " opcion

    case $opcion in
        1) puertos ;;
        2) equipos ;;
        3) sistema_operativo ;;
        4) dos_simulado ;;
        5) ver_ip ;;
        6) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida. Intenta otra vez." ;;
    esac

    read -p "Presiona Enter para continuar..."
done
