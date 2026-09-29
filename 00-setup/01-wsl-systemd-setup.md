# Setup Environment WSL2 openSUSE Leap 16.0
1. Enable systemd: `echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf`
2. Config resource limits via `.wslconfig` (RAM 10GB, CPU 8 Cores, Swap 4GB).
