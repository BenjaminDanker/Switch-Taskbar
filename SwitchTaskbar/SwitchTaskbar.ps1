# get taskbar settings
$Settings = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings).Settings

if ($Settings[27] -ne 0xFF) {
	# change taskbar settings
	$Settings[27] = 0xFF  # first monitor = 0x00  second monitor = 0xFF

	# to change position to top, bottom, left, right
	# only changes main taskbar
	# subsidiary taskbar keeps last position of respective monitor
	#$Settings[12] = 0x00  # left=0x00  top=0x01  right=0x02  bottom=0x03


	# set taskbar settings
	Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -Value $Settings

	# reset windows explorer
	# taskbar changes do not show without restarting windows explorers
	Get-Process explorer | Stop-Process
}
