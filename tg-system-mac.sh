#!/bin/bash
 
OutputPath="$HOME"
 
# Gather system information
SystemName=$(scutil --get ComputerName)
SystemManufacturer="Apple"
SystemModel=$(sysctl -n hw.model | cut -d"," -f1)
SystemSerialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
 
ProcessorName=$(sysctl -n machdep.cpu.brand_string)
RAMCapacity=$(sysctl -n hw.memsize)
RAMCapacity=$(expr $RAMCapacity / $((1024**3)))
RAMType=$(system_profiler SPMemoryDataType | awk '/Type/ {print $2}' | xargs | cut -d" " -f1)
RAMManufacturer=$(system_profiler SPMemoryDataType | awk '/Manufacturer/ {print $2 " " $3}' |  xargs | cut -d" " -f1,2)
RAMSerial=$(system_profiler SPMemoryDataType | awk '/Part Number/ {print $3}' | xargs | cut -d" " -f1)
StorageCapacity=$(df -H / | awk 'NR==2 {print $2}')
StorageType=$(system_profiler SPStorageDataType | awk '/Medium Type/ {print $3}' | xargs | cut -d" " -f1)
StorageModel=$(system_profiler SPStorageDataType | awk '/Device/ {print $3 " " $4 " "  $5}' | xargs | cut -d" " -f1,2,3)
StorageSerial=$(system_profiler SPStorageDataType | awk '/Serial/ {print $4}')
OS=$(sw_vers -productName)
OSVersion=$(sw_vers -productVersion)
OSBuild=$(sw_vers -buildVersion)
OSArchitecture=$(uname -m)
 
Date=$(date +"%y%m%d%H%M%S")
FileName="${HOSTNAME}_CollectSystemInfo_$Date"
OutputFile="${OutputPath}/${FileName}.csv"
 
# Create CSV file with gathered information
echo -e "Device Name, Device Manufacturer, Device Model, Device Serial Number, Processor, RAM Capacity, RAM Type, RAM Manufacturer, RAM Serial, Storage Capacity, Storage Type, Storage Model, Storage Serial, OS, OS Version, OS Build, OS Architecture" > "$OutputFile"
echo -e "$SystemName, $SystemManufacturer, $SystemModel, $SystemSerialNumber, $ProcessorName, $RAMCapacity, $RAMType, $RAMManufacturer, $RAMSerial, $StorageCapacity, $StorageType, $StorageModel, $StorageSerial, $OS, $OSVersion, $OSBuild, $OSArchitecture" >> "$OutputFile"
 
open "${OutputPath}"
echo "System information saved to $OutputFile."











