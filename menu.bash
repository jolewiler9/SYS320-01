#!/bin/bash

# Menu for admin and Security functions

function menu()  {

    # Wipes previous info from screen
    clear

    echo "[1] Admin Menu"
    echo "[2] Security Menu"
    echo "[3] Exit"
    read -p "Please enter a choice: " choice

    case "$choice" in

        1) admin_menu

        ;;
        2) security_menu

        ;;
        3) exit 0

        ;;
        *)

           echo ""
           echo "Invalid option"
           echo ""
           sleep 2

           # Calls main menu
           menu

        ;;
    esac

}

function admin_menu()  {

    clear

    echo "[C]heck Root Users"
    echo "[P]reviously Logged In"
    echo "[L]ogged In"
    echo "[N}etwork Sockets"
    echo "[V]PN Menu"
    echo "[4] Exit"
    read -p "Please enter a choice: " choice

    case "$choice" in

        # Checks the passwd file for a user besides root with a UID of 0
        C|c) awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd |less
        ;;
        # Checks the last 10 logged in users
        P|p) last -n 10 |less
        ;;
        # Shows currently logged in users
        L|l) who |less
        ;;
        N|n) netstat -an --inet |less
        ;;
        V|v) vpn_menu
        ;;
        4) exit 0
        ;;
        *)

           echo ""
           echo "Invalid option"
           echo ""
           sleep 2

           # Calls admin menu
           admin_menu

        ;;



    esac

admin_menu
}

function vpn_menu()  {

    clear

    echo "[A]dd a user"
    echo "[D]elete a user"
    echo "[B]ack to admin menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please enter a choice: " choice

    case "$choice" in

        A|a)

         bash peer.bash
         tail -7 wg0.conf |less
        ;;
        D|d)
             # Create prompt for  user
             # Call the manage-user.bash and pass proper switches to delete user

        ;;
        B|b) admin_menu
        ;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *)

           echo ""
           echo "Invalid option"
           echo ""
           sleep 2

           # Calls VPN menu
           vpn_menu

        ;;
    esac

vpn_menu
}
# Calls the main function
menu
