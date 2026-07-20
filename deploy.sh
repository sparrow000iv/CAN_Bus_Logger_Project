#!/bin/bash

# Deploy script for CAN Bus Logger
# This script helps with building, testing, and deploying the CAN logger

set -e  # Exit on error

echo "=== CAN Bus Logger - Deployment Script ==="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please don't run this script as root"
        print_info "Run without sudo, it will ask for password when needed"
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    # Check for gcc
    if ! command -v gcc &> /dev/null; then
        print_error "GCC not found"
        print_info "Installing build tools..."
        sudo apt-get update
        sudo apt-get install -y build-essential
    fi
    
    # Check for can-utils
    if ! command -v candump &> /dev/null; then
        print_info "Installing can-utils..."
        sudo apt-get install -y can-utils
    fi
    
    # Check for Python
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 not found"
        print_info "Installing Python3..."
        sudo apt-get install -y python3
    fi
    
    print_success "All dependencies checked"
}

# Build the CAN logger
build_logger() {
    print_info "Building CAN logger..."
    make clean
    make all
    print_success "CAN logger built successfully"
}

# Setup virtual CAN interface
setup_vcan() {
    print_info "Setting up virtual CAN interface..."
    make setup_vcan
    print_success "Virtual CAN interface ready"
}

# Remove virtual CAN interface
remove_vcan() {
    print_info "Removing virtual CAN interface..."
    make remove_vcan
    print_success "Virtual CAN interface removed"
}

# Test CAN communication
test_can() {
    print_info "Testing CAN communication..."
    make test
    print_success "CAN test completed"
}

# Analyze CAN logs
analyze_logs() {
    print_info "Analyzing CAN logs..."
    make analyze
    print_success "Analysis completed"
}

# Export CAN logs
export_logs() {
    print_info "Exporting CAN logs to CSV..."
    make export
    print_success "Export completed"
}

# Monitor CAN bus
monitor_can() {
    print_info "Starting CAN bus monitor..."
    make monitor
}

# Send test frames
send_test_frames() {
    print_info "Sending test CAN frames..."
    make send_test
    print_success "Test frames sent"
}

# Show CAN info
show_info() {
    print_info "Showing CAN information..."
    make info
}

# Show logs
show_logs() {
    print_info "Showing kernel logs..."
    make logs
}

# Run comprehensive test
run_comprehensive_test() {
    print_info "Running comprehensive CAN test..."
    echo ""
    
    # Build logger
    print_info "Step 1: Building CAN logger..."
    build_logger
    echo ""
    
    # Setup vcan
    print_info "Step 2: Setting up virtual CAN..."
    setup_vcan
    echo ""
    
    # Run test
    print_info "Step 3: Testing CAN communication..."
    test_can
    echo ""
    
    # Analyze logs
    print_info "Step 4: Analyzing CAN logs..."
    analyze_logs
    echo ""
    
    # Export logs
    print_info "Step 5: Exporting logs to CSV..."
    export_logs
    echo ""
    
    print_success "Comprehensive test completed!"
    echo ""
    print_info "Check the following files:"
    echo "  - can_log.txt: CAN frame log"
    echo "  - can_export.csv: CSV export"
}

# Clean build artifacts
clean_build() {
    print_info "Cleaning build artifacts..."
    make clean
    print_success "Clean completed"
}

# Show help
show_help() {
    echo "Usage: ./deploy.sh [command]"
    echo ""
    echo "Commands:"
    echo "  build         - Build CAN logger"
    echo "  setup_vcan    - Setup virtual CAN interface"
    echo "  remove_vcan   - Remove virtual CAN interface"
    echo "  test          - Test CAN communication"
    echo "  analyze       - Analyze CAN log file"
    echo "  export        - Export CAN log to CSV"
    echo "  monitor       - Monitor CAN bus in real-time"
    echo "  send_test     - Send test CAN frames"
    echo "  info          - Show CAN interface information"
    echo "  logs          - View kernel messages for CAN"
    echo "  comprehensive - Run comprehensive test"
    echo "  clean         - Clean build artifacts"
    echo "  help          - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh build         # Build the CAN logger"
    echo "  ./deploy.sh test          # Test CAN communication"
    echo "  ./deploy.sh comprehensive # Run full test suite"
}

# Main script
main() {
    check_root
    
    case "${1:-help}" in
        build)
            check_dependencies
            build_logger
            ;;
        setup_vcan)
            setup_vcan
            ;;
        remove_vcan)
            remove_vcan
            ;;
        test)
            test_can
            ;;
        analyze)
            analyze_logs
            ;;
        export)
            export_logs
            ;;
        monitor)
            monitor_can
            ;;
        send_test)
            send_test_frames
            ;;
        info)
            show_info
            ;;
        logs)
            show_logs
            ;;
        comprehensive)
            check_dependencies
            run_comprehensive_test
            ;;
        clean)
            clean_build
            ;;
        help|*)
            show_help
            ;;
    esac
}

main "$@"
