#!/bin/bash

# Function to get basic system's details
get_system_details() {
    echo "\"Device Name\",\"Device Manufacturer\",\"Device Model\",\"Device Serial Number\",\"Processor\",\"RAM Capacity\",\"Storage Capacity\",\"Storage Type\",\"Storage Bus Type\",\"OS\",\"OS Version\",\"OS Build\",\"OS Architecture\",\"RAM Serial Number\",\"Hard Disk Serial Number\",\"RAM Type\",\"RAM Manufacturer\",\"RAM Serial\",\"Storage Model\",\"Storage Serial\""

    device_name=$(sudo uname -n)
    manufacturer=$(sudo dmidecode -s system-manufacturer)
    model=$(sudo dmidecode -s system-product-name)
    serial_number=$(sudo dmidecode -s system-serial-number)
    processor=$(sudo lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    ram_capacity=$(sudo free -h | awk '/Mem:/ {print $2}')
    storage_capacity=$(sudo df -h --total | awk '/total/ {print $2}')
    storage_info=$(sudo lsblk -d -o NAME,SIZE,TYPE,TRAN,SERIAL | grep disk | head -n 1)
    storage_type=$(sudo echo "$storage_info" | awk '{print $3}')
    storage_bus_type=$(sudo echo "$storage_info" | awk '{print $4}')
    os=$(sudo lsb_release -d | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_version=$(sudo lsb_release -r | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_build=$(sudo lsb_release -a | grep "Codename" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_architecture=$(sudo uname -m)
    ram_serial_number=$(sudo dmidecode -t 17 | grep "Serial Number" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    hard_disk_serial_number=$(sudo echo "$storage_info" | awk '{print $5}')

    RAMType=$(sudo dmidecode -t memory | grep "Type:" | awk '{print $2}' | tr '\n' ', ' | sed 's/, $//')
    RAMManufacturer=$(sudo dmidecode -t memory | grep "Manufacturer:" | awk '{print $2 $3}' | tr '\n' ', ' | sed 's/, $//')
    RAMSerial=$(sudo dmidecode -t memory | grep "Serial Number:" | awk '{print $3}' | tr '\n' ', ' | sed 's/, $//')
    StorageModel=$(sudo lsblk --output MODEL -n | tr '\n' ', ' | sed 's/, $//')
    StorageSerial=$(sudo lsblk --output SERIAL -n | tr '\n' ', ' | sed 's/, $//')

    echo "\"$device_name\",\"$manufacturer\",\"$model\",\"$serial_number\",\"$processor\",\"$ram_capacity\",\"$storage_capacity\",\"$storage_type\",\"$storage_bus_type\",\"$os\",\"$os_version\",\"$os_build\",\"$os_architecture\",\"$ram_serial_number\",\"$hard_disk_serial_number\",\"$RAMType\",\"$RAMManufacturer\",\"$RAMSerial\",\"$StorageModel\",\"$StorageSerial\""
}


OutputPath="$HOME"
Date=$(date +"%y%m%d%H%M%S")
FileName="${HOSTNAME}_CollectSystemInfo_$Date"
OutputFile="${OutputPath}/${FileName}.csv"


get_system_details > $OutputFile

echo "The file$FileName is been save to $OutputFile"







