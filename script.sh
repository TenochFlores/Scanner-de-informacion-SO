#!/bin/bash

# Alumno: Tenoch Itzin Flores Rojas
# Ruta del archivo de salida
archivo_salida="Informacion.txt"

# Abre el archivo para escribir o crea uno nuevo si no existe
exec > "$archivo_salida"

#================================== Usuarios ==========================================

echo "============================================================================="
echo "========================= Nombres de usuario ================================"
echo "============================================================================="

# Ruta del archivo /etc/passwd
archivo_passwd="/etc/passwd"

# Verificar si el archivo existe
if [ -f "$archivo_passwd" ]; then
    # Utilizar el comando awk para extraer el primer campo (nombre de usuario) de cada línea
    usuarios=$(awk -F':' '{print $1}' "$archivo_passwd")

    # Imprimir la lista de usuarios
    echo "Usuarios del sistema:"
    echo "$usuarios"
else
    echo "El archivo $archivo_passwd no existe."
fi

#======================================================================================

echo "=============================================================================" 
echo "======================= Historial de comandos ==============================="
echo "============================================================================="

archivo="/home/kali/.zsh_history" 
#En mi caso que uso kali linux el archivo es .zsh_history pero puede que
#en otros casos el archivo sea .bash_history

if [ -f "$archivo" ]; then
    cat "$archivo"
else
    echo "El archivo $archivo no existe."
fi

echo "============================================================================="
echo "======================= Procesos en ejecucion ==============================="
echo "============================================================================="

#aux para mostrar procesos de todos los usuarios, su informacion detallada y los que no esten asociados a una terminal pero que estan en ejecucion
ps aux 

echo "============================================================================="
echo "=========================== Interfaces de red ==============================="
echo "============================================================================="
ip a

echo "============================================================================="
echo "===================== Archivos de config importantes ========================"
echo "============================================================================="
echo " " 

echo "====================== Configuracion de servidor SSH ========================"
archivo_config="/etc/ssh/sshd_config" 
#En mi caso que uso kali linux el archivo es .zsh_history pero puede que
#en otros casos el archivo sea .bash_history

if [ -f "$archivo_config" ]; then
    cat "$archivo_config"
else
    echo "El archivo $archivo_config no existe."
fi

echo "=================== Informacion de los grupos del sistema ====================="
group="/etc/group" 
#En mi caso que uso kali linux el archivo es .zsh_history pero puede que
#en otros casos el archivo sea .bash_history

if [ -f "$group" ]; then
    cat "$group"
else
    echo "El archivo $group no existe."
fi

echo "========================= Configuracion del Kernel ============================"
kernel="/etc/sysctl.conf" 
#En mi caso que uso kali linux el archivo es .zsh_history pero puede que
#en otros casos el archivo sea .bash_history

if [ -f "$kernel" ]; then
    cat "$kernel"
else
    echo "El archivo $kernel no existe."
fi

# Cierra la redirección al archivo
exec > /dev/tty

echo "=============================================================================" >> "$archivo_salida"
echo "===================== Archivos asociados a los procesos =====================" >> "$archivo_salida"
echo "=============================================================================" >> "$archivo_salida"

echo "¿Quieres incluir tambien los archivos asociados a los procesos? (y/n)"
read respuesta

if [ "$respuesta" == "y" ]; then
    sudo lsof &>/dev/null

    # Verificar si el comando lsof se ejecutó exitosamente
    if [ "$?" -eq 0 ]; then
        sudo lsof >> "$archivo_salida" 2>/dev/null
    else
        echo "Se requieren privilegios de superusuario para esta funcion"
        exit 1
    fi
    
elif [ "$respuesta" == "n" ]; then
    echo "Respuesta no válida. Se esperaba 'y' o 'n'."
fi

echo "============================================================================="
echo "========================= Salida en $archivo_salida ========================="
echo "============================================================================="
