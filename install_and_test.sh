#!/bin/bash

# Installation and Testing Script for Reservoir-LM

echo "=========================================="
echo "  Reservoir-LM Setup and Test"
echo "=========================================="
echo ""

# Function to print colored output
print_status() {
    echo -e "\033[1;34m[*]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[✓]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[✗]\033[0m $1"
}

# Check Python version
print_status "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "  Found Python $python_version"

if python3 -c 'import sys; exit(0 if sys.version_info >= (3,8) else 1)'; then
    print_success "Python version OK"
else
    print_error "Python 3.8+ required"
    exit 1
fi

# Create virtual environment (optional)
read -p "Create virtual environment? (recommended) [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    print_success "Virtual environment created and activated"
fi

# Install dependencies
print_status "Installing dependencies..."
pip install -q -r requirements.txt

if [ $? -eq 0 ]; then
    print_success "Dependencies installed"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Install package in development mode
print_status "Installing reservoir-lm package..."
pip install -q -e .

if [ $? -eq 0 ]; then
    print_success "Package installed"
else
    print_error "Failed to install package"
    exit 1
fi

# Create necessary directories
print_status "Creating directories..."
mkdir -p models data/sample outputs

# Run tests
echo ""
print_status "Running tests..."
echo ""

# Test 1: Reservoir
echo "Test 1: Core Reservoir"
python3 -c "from reservoir_lm.core.reservoir import test_reservoir, test_multi_reservoir; test_reservoir(); test_multi_reservoir()"

if [ $? -eq 0 ]; then
    print_success "Reservoir tests passed"
else
    print_error "Reservoir tests failed"
fi

# Test 2: Readout
echo ""
echo "Test 2: Readout Layers"
python3 -c "from reservoir_lm.core.readout import test_readouts; test_readouts()"

if [ $? -eq 0 ]; then
    print_success "Readout tests passed"
else
    print_error "Readout tests failed"
fi

# Test 3: Embeddings
echo ""
echo "Test 3: Embeddings"
python3 -c "from reservoir_lm.core.embeddings import test_embeddings; test_embeddings()"

if [ $? -eq 0 ]; then
    print_success "Embedding tests passed"
else
    print_error "Embedding tests failed"
fi

# Test 4: Tokenizer
echo ""
echo "Test 4: Tokenizer"
python3 -c "from reservoir_lm.tokenization.tokenizer import test_tokenizers; test_tokenizers()"

if [ $? -eq 0 ]; then
    print_success "Tokenizer tests passed"
else
    print_error "Tokenizer tests failed"
fi

# Test 5: Full model
echo ""
echo "Test 5: Complete Model"
python3 -c "from reservoir_lm.core.model import test_model; test_model()"

if [ $? -eq 0 ]; then
    print_success "Model tests passed"
else
    print_error "Model tests failed"
fi

# Run basic example
echo ""
read -p "Run basic training example? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Running basic example..."
    python3 examples/basic_training.py
    
    if [ $? -eq 0 ]; then
        print_success "Basic example completed"
    else
        print_error "Basic example failed"
    fi
fi

# Summary
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Try: python examples/basic_training.py"
echo "  2. Try: python examples/comprehensive_demo.py"
echo "  3. Read: docs/quickstart.md"
echo "  4. Train your own: python scripts/train.py --data your_data.txt --output model.pkl"
echo ""
echo "For help:"
echo "  - Documentation: docs/"
echo "  - Examples: examples/"
echo "  - Issues: https://github.com/yourusername/reservoir-lm/issues"
echo ""
