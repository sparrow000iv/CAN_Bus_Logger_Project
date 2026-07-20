# Makefile for CAN Bus Logger using SocketCAN
#
# This Makefile supports:
# - Building the CAN logger
# - Setting up virtual CAN interface
# - Testing CAN communication
# - Analyzing CAN logs

# Compiler
CC = gcc
CFLAGS = -Wall -Wextra -O2

# Python interpreter
PYTHON = python3

# Source directory
SRC_DIR = src

# Build directory
BUILD_DIR = build

# Output files
CAN_LOGGER = can_logger
CAN_PARSER = can_parser.py

# Default target
all: build_dir $(CAN_LOGGER)

# Create build directory
build_dir:
	@mkdir -p $(BUILD_DIR)

# Build CAN logger
$(CAN_LOGGER): $(SRC_DIR)/can_logger.c
	@echo "Building CAN logger..."
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(CAN_LOGGER) $(SRC_DIR)/can_logger.c
	@echo "CAN logger built successfully"

# Setup virtual CAN interface
setup_vcan:
	@echo "Setting up virtual CAN interface..."
	sudo modprobe vcan
	sudo ip link add dev vcan0 type vcan
	sudo ip link set up vcan0
	@echo "Virtual CAN interface 'vcan0' created and activated"

# Remove virtual CAN interface
remove_vcan:
	@echo "Removing virtual CAN interface..."
	sudo ip link set down vcan0 2>/dev/null || true
	sudo ip link delete vcan0 2>/dev/null || true
	@echo "Virtual CAN interface removed"

# Test CAN communication
test: all setup_vcan
	@echo "Testing CAN communication..."
	@echo ""
	@echo "Starting CAN logger in background..."
	$(BUILD_DIR)/$(CAN_LOGGER) vcan0 &
	LOGGER_PID=$!
	sleep 2
	@echo ""
	@echo "Sending test CAN frames..."
	cansend vcan0 100#0102030405060708
	cansend vcan0 200#6400000000000000
	cansend vcan0 300#6450000000000000
	cansend vcan0 400#1900000000000000
	@echo ""
	@echo "Waiting for logger to process frames..."
	sleep 2
	kill $$LOGGER_PID 2>/dev/null || true
	@echo ""
	@echo "Test completed. Check can_log.txt for logged frames."

# Analyze CAN log
analyze:
	@echo "Analyzing CAN log..."
	@if [ -f "can_log.txt" ]; then \
		$(PYTHON) $(SRC_DIR)/$(CAN_PARSER) can_log.txt --summary; \
	else \
		echo "No log file found. Run 'make test' first."; \
	fi

# Export CAN log to CSV
export:
	@echo "Exporting CAN log to CSV..."
	@if [ -f "can_log.txt" ]; then \
		$(PYTHON) $(SRC_DIR)/$(CAN_PARSER) can_log.txt --export can_export.csv; \
	else \
		echo "No log file found. Run 'make test' first."; \
	fi

# Monitor CAN bus in real-time
monitor: setup_vcan
	@echo "Monitoring CAN bus (press Ctrl+C to stop)..."
	@echo "In another terminal, send frames with: cansend vcan0 100#01020304"
	candump vcan0

# Send test frames
send_test: setup_vcan
	@echo "Sending test CAN frames..."
	cansend vcan0 100#0102030405060708
	cansend vcan0 200#6400000000000000
	cansend vcan0 300#6450000000000000
	cansend vcan0 400#1900000000000000
	@echo "Test frames sent"

# Show CAN interface info
info:
	@echo "CAN Interface Information:"
	@echo "========================="
	@echo ""
	@echo "Available CAN interfaces:"
	@ip link show type vcan 2>/dev/null || echo "No virtual CAN interfaces"
	@echo ""
	@echo "CAN interface details:"
	@if [ -d "/sys/class/net/vcan0" ]; then \
		echo "vcan0:"; \
		cat /sys/class/net/vcan0/operstate; \
		cat /sys/class/net/vcan0/type; \
	else \
		echo "vcan0 not found"; \
	fi

# View kernel messages for CAN
logs:
	@echo "Recent CAN kernel messages:"
	dmesg | grep -i can | tail -20

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -f can_log.txt can_export.csv
	@echo "Clean completed"

# Show help
help:
	@echo "Available targets:"
	@echo "  all          - Build CAN logger"
	@echo "  setup_vcan   - Setup virtual CAN interface"
	@echo "  remove_vcan  - Remove virtual CAN interface"
	@echo "  test         - Test CAN communication"
	@echo "  analyze      - Analyze CAN log file"
	@echo "  export       - Export CAN log to CSV"
	@echo "  monitor      - Monitor CAN bus in real-time"
	@echo "  send_test    - Send test CAN frames"
	@echo "  info         - Show CAN interface information"
	@echo "  logs         - View kernel messages for CAN"
	@echo "  clean        - Clean build artifacts"
	@echo "  help         - Show this help message"

.PHONY: all build_dir setup_vcan remove_vcan test analyze export monitor send_test info logs clean help
