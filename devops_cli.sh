#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_menu() {
    clear
    echo "=============================================="
    echo "    ENTERPRESE DEVOPS CONTROL PLANE & DIAGNOSTICS "
    echo "=============================================="
    echo "1. [01-Linux] Run Advanced Log Parser Engine"
    echo "2. [01-Linux] Execute Hands-on System Profiling"
    echo "3. [02-Networking] Run Network & SSL Diagnostics Tool"
    echo "4. [03-Docker] Deploy Multi-Container Microservices Stack"
    echo "5. [03-Docker] Check Microservices Status & Health"
    echo "6. [03-Docker] Stop & Clean Container Stack"
    echo "7. Exit Control Plane"
    echo "=============================================="
    read -rp "Select option [1-7]: " choice

    case $choice in
        1)
            bash "$SCRIPT_DIR/01-linux/advanced_log_parser.sh"
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        2)
            bash "$SCRIPT_DIR/01-linux/hands_on_practice.sh"
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        3)
            read -rp "Enter target domain (e.g. github.com): " domain
            bash "$SCRIPT_DIR/02-networking/production_net_diag.sh" "${domain:-github.com}" 443
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        4)
            cd "$SCRIPT_DIR/03-docker" && docker compose up -d --build
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        5)
            cd "$SCRIPT_DIR/03-docker" && docker compose ps
            echo -e "\nTesting Endpoint Response:"
            curl -s http://localhost:8080/health || echo "API Offline"
            echo ""
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        6)
            cd "$SCRIPT_DIR/03-docker" && docker compose down
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        7)
            echo "Exiting Control Plane."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            sleep 1
            show_menu
            ;;
    esac
}

show_menu
