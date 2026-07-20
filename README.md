# CAN Bus Communication Logger using SocketCAN

[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Linux](https://img.shields.io/badge/Linux-SocketCAN-orange.svg)](https://www.kernel.org/)
[![C](https://img.shields.io/badge/Language-C-blue.svg)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Python](https://img.shields.io/badge/Language-Python-yellow.svg)](https://www.python.org/)

A comprehensive CAN bus data logger and analyzer using Linux SocketCAN API. This project demonstrates automotive bus communication patterns relevant to platform-layer peripheral integration in electric vehicles.

## 📋 Features

- **SocketCAN API** - Native Linux CAN bus communication
- **CAN Frame Sending** - Send CAN frames via SocketCAN
- **CAN Frame Capture** - Capture and log CAN frames in real-time
- **Virtual CAN (vcan)** - Test without physical CAN hardware
- **Frame Parsing** - Parse and analyze CAN frame data
- **Data Logging** - Log CAN frames with timestamps
- **Statistics Analysis** - Generate CAN bus statistics
- **CSV Export** - Export logs for further analysis

## 🛠️ Technologies Used

- **Languages:** C, Python
- **Linux APIs:** SocketCAN, CAN_RAW socket
- **CAN Tools:** candump, cansend, cansniffer
- **Debug Tools:** dmesg, kernel log analysis

## 📁 Project Structure

```
can-bus-logger/
│
├── src/
│   ├── can_logger.c           # Main CAN logger (C)
│   └── can_parser.py          # CAN frame parser (Python)
│
├── scripts/
│   └── test_can.sh            # CAN testing script
│
├── docs/
│   └── (Documentation)
│
├── examples/
│   └── (Usage examples)
│
├── Makefile                    # Build system
├── deploy.sh                   # Deployment automation
├── .gitignore                  # Git ignore rules
├── LICENSE                     # GPL v2 license
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites

- Linux system (Ubuntu/Debian recommended)
- CAN utilities (candump, cansend)
- GCC compiler
- Python 3.x

### Install Dependencies

```bash
# Update package list
sudo apt-get update

# Install build tools
sudo apt-get install -y build-essential

# Install CAN utilities
sudo apt-get install -y can-utils

# Install Python (if not already installed)
sudo apt-get install -y python3
```

### Build the Logger

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/can-bus-logger.git
cd can-bus-logger

# Build the CAN logger
make all

# Or use deploy script
./deploy.sh build
```

### Setup Virtual CAN Interface

```bash
# Create virtual CAN interface
make setup_vcan

# Or use deploy script
./deploy.sh setup_vcan
```

### Test CAN Communication

```bash
# Run comprehensive test
make test

# Or use deploy script
./deploy.sh test
```

## 📖 How It Works

### 1. CAN Socket Setup (`setup_can_socket`)

The logger creates a CAN socket using SocketCAN API:

```c
// Create CAN socket
socket_fd = socket(PF_CAN, SOCK_RAW, CAN_RAW);

// Get interface index
ioctl(socket_fd, SIOCGIFINDEX, &ifr);

// Bind socket to CAN interface
bind(socket_fd, (struct sockaddr *)&addr, sizeof(addr));
```

### 2. Sending CAN Frames (`send_can_frame`)

Send CAN frames with specific ID and data:

```c
struct can_frame frame;
frame.can_id = 0x100;  // CAN ID
frame.can_dlc = 8;     // Data length
memcpy(frame.data, data, 8);

write(socket_fd, &frame, sizeof(struct can_frame));
```

### 3. Receiving CAN Frames (`receive_can_frame`)

Receive CAN frames in non-blocking mode:

```c
bytes_received = read(socket_fd, &frame, sizeof(struct can_frame));
if (bytes_received > 0) {
    // Process received frame
    log_can_frame(&frame, "RX");
}
```

### 4. Virtual CAN Interface

Create virtual CAN interface for testing without hardware:

```bash
# Load vcan kernel module
sudo modprobe vcan

# Create virtual CAN interface
sudo ip link add dev vcan0 type vcan

# Bring interface up
sudo ip link set up vcan0
```

## 🧪 Testing

### Build and Test

```bash
# Build and run comprehensive test
./deploy.sh comprehensive

# Or step by step
make all
make setup_vcan
make test
make analyze
```

### Manual Testing

```bash
# Setup virtual CAN
make setup_vcan

# Monitor CAN bus (in one terminal)
make monitor

# Send test frames (in another terminal)
make send_test

# Run CAN logger
./build/can_logger vcan0

# Analyze logs
make analyze
```

### Expected Output

```
=== CAN Bus Logger using SocketCAN ===
Interface: vcan0
Log file: can_log.txt

Virtual CAN interface 'vcan0' created successfully
CAN socket opened successfully on interface: vcan0

Sending test CAN frames...
[TX] ID: 0x100 DLC: 8 Data: 01 02 03 04 05 06 07 08
[TX] ID: 0x200 DLC: 4 Data: 64 00 00 00
[TX] ID: 0x300 DLC: 8 Data: 64 50 00 00 00 00 00 00
[TX] ID: 0x400 DLC: 2 Data: 19 00

Listening for CAN frames...
================================
[RX] ID: 0x100 DLC: 8 Data: 01 02 03 04 05 06 07 08
[RX] ID: 0x200 DLC: 4 Data: 64 00 00 00
[RX] ID: 0x300 DLC: 8 Data: 64 50 00 00 00 00 00 00
[RX] ID: 0x400 DLC: 2 Data: 19 00

================================
Total frames received: 4
CAN logger stopped.
```

## 📊 CAN Frame Analysis

### Log File Format

```
[2024-01-15 10:30:45] TX ID: 0x100 DLC: 8 Data: 01 02 03 04 05 06 07 08
[2024-01-15 10:30:45] RX ID: 0x100 DLC: 8 Data: 01 02 03 04 05 06 07 08
[2024-01-15 10:30:46] TX ID: 0x200 DLC: 4 Data: 64 00 00 00
```

### Analysis Summary

```
=== CAN Bus Analysis Summary ===
Total frames: 100
TX frames: 50
RX frames: 50
Unique CAN IDs: 4
Time span: 10.50 seconds
Average frames/sec: 9.52

--- CAN ID Distribution ---
  0x100 (Engine RPM): 25 frames
  0x200 (Vehicle Speed): 25 frames
  0x300 (Battery Status): 25 frames
  0x400 (Temperature): 25 frames
```

## 🔍 CAN Message IDs

### Common Automotive CAN IDs

| CAN ID | Message | Description |
|--------|---------|-------------|
| 0x100 | Engine RPM | Engine revolutions per minute |
| 0x200 | Vehicle Speed | Current vehicle speed |
| 0x300 | Battery Status | Battery charge level |
| 0x400 | Temperature | Engine/motor temperature |
| 0x500 | Brake Status | Brake pedal position |
| 0x600 | Steering Angle | Steering wheel angle |
| 0x700 | Light Status | Headlight/turn signal status |
| 0x7DF | OBD-II Request | Diagnostic request |
| 0x7E8 | OBD-II Response | Diagnostic response |

### Adding Custom Messages

Edit `src/can_parser.py` to add custom message definitions:

```python
KNOWN_MESSAGES = {
    0x100: "Engine RPM",
    0x200: "Vehicle Speed",
    # Add your custom messages here
    0x800: "Custom Message",
}
```

## 🛠️ CAN Tools Reference

### candump

Capture and display CAN frames:

```bash
# Monitor all CAN traffic
candump vcan0

# Monitor specific ID
candump vcan0,100:7FF

# Log to file
candump -l vcan0
```

### cansend

Send CAN frames:

```bash
# Send single frame
cansend vcan0 100#0102030405060708

# Send with specific DLC
cansend vcan0 200#64000000
```

### cansniffer

Analyze CAN traffic patterns:

```bash
# Sniff CAN bus
cansniffer vcan0
```

## 📚 Learning Resources

- [SocketCAN Documentation](https://www.kernel.org/doc/html/latest/networking/can.html)
- [Linux CAN Utilities](https://github.com/linux-can/can-utils)
- [CAN Bus Protocol](https://en.wikipedia.org/wiki/CAN_bus)
- [SocketCAN Tutorial](https://www.embarcados.com.br/socketcan-english/)

## 🎯 Key Concepts Demonstrated

- **SocketCAN API** - Native Linux CAN bus communication
- **CAN_RAW Socket** - Raw CAN frame handling
- **Virtual CAN (vcan)** - Testing without hardware
- **Frame Parsing** - CAN ID and data extraction
- **Data Logging** - Timestamped frame logging
- **Automotive Communication** - Vehicle bus patterns

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the GPL License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Tushar Kumar**
- Email: sparrow000iv@gmail.com

## 🙏 Acknowledgments

- Linux Kernel SocketCAN Documentation
- CAN Utilities (can-utils) Project
- Automotive Linux Community
- Open Source CAN Bus Tools

---

⭐ If you found this project helpful, please give it a star!
