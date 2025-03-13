# Create a New Recovery Partition (PowerShell)
Get-Disk
Get-Partition -DiskNumber 0
$partSize= (Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 3).Size
Resize-Partition -DiskNumber 0 -PartitionNumber 3 -Size ($partSize-1GB)
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter "R" -GptType "{de94bba4-06d1-4d40-a16a-bfd50179d6ac}"
Format-Volume -DriveLetter R -FileSystem NTFS -NewFileSystemLabel "Recovery"
New-Item -ItemType Directory -Path "R:\Recovery\WindowsRE"
New-Item -ItemType Directory -Path "C:\Temp\DISM\Mount"
Dism.exe /mount-image /imagefile:D:\sources\install.wim /Index:1 /Mountdir:C:\Temp\DISM\Mount /readonly /optimize
Robocopy.exe /MIR /XJ C:\Temp\DISM\Mount\Windows\System32\Recovery\ C:\Windows\System32\Recovery\
Copy-Item -Force C:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE\
Dism.exe /unmount-image /mountdir:C:\Temp\DISM\Mount /discard
ReAgentc.exe /setreimage /path R:\Recovery\WindowsRE\
ReAgentc.exe /enable
Get-Partition -DiskNumber 0 -PartitionNumber 4 | Remove-PartitionAccessPath -AccessPath "R:"
Remove-Item -Recurse -Force -Path C:\Temp\DISM
ReAgentc.exe /info


# Delete Microsoft OE Recovery Partition (DISKPART)
DISKPART
LIST DISK
SELECT DISK 0
LIST PARTITION
SELECT PARTITION 4
DELETE PARTITION OVERRIDE

# Delete Microsoft OE Recovery Partition (PowerShell)
Get-Disk
Get-Partition -DiskNumber 0
Remove-Partition -DiskNumber 0 -PartitionNumber 4


# Expand C: Drive Partition (PowerShell)
Get-Disk
Get-Partition -DiskNumber 0
$maxPartSize=(Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 3).SizeMax
Resize-Partition -DiskNumber 0 -PartitionNumber 3 -Size $maxPartSize
Get-Partition -DiskNumber 0


