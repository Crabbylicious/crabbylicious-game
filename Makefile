.PHONY: setup install-tools setup-hooks format lint validate clean-hooks

# One-command setup for new team members
setup: install-tools setup-hooks
	@echo ""
	@echo "🎉 Development environment setup complete!"
	@echo ""
	@echo "📋 What's configured:"
	@echo "   ✅ SwiftFormat and SwiftLint installed"
	@echo "   ✅ Pre-commit hooks installed with Lefthook"
	@echo "   ✅ Code will be auto-formatted on commit"
	@echo "   ✅ Linting will run before commits and pushes"
	@echo ""
	@echo "💡 Try making a commit to see the hooks in action!"

# Install required development tools
install-tools:
	@echo "🛠️  Installing development tools..."
	@command -v brew >/dev/null 2>&1 || { echo "❌ Homebrew not found. Please install Homebrew first: https://brew.sh"; exit 1; }
	
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		echo "📦 Installing SwiftFormat..."; \
		brew install swiftformat; \
	else \
		echo "✅ SwiftFormat already installed"; \
	fi
	
	@if ! command -v swiftlint >/dev/null 2>&1; then \
		echo "📦 Installing SwiftLint..."; \
		brew install swiftlint; \
	else \
		echo "✅ SwiftLint already installed"; \
	fi
	
	@if ! command -v lefthook >/dev/null 2>&1; then \
		echo "📦 Installing Lefthook..."; \
		brew install lefthook; \
	else \
		echo "✅ Lefthook already installed"; \
	fi

# Setup git hooks with Lefthook
setup-hooks:
	@echo "🔧 Setting up git hooks..."
	@if [ ! -f lefthook.yml ]; then \
		echo "❌ lefthook.yml not found. Make sure you're in the project root."; \
		exit 1; \
	fi
	lefthook install
	@echo "✅ Git hooks installed!"

# Format Swift code manually
format:
	@echo "🔧 Formatting Swift code..."
	swiftformat . --indent 2 --swiftversion 5.9
	@echo "✅ Code formatted!"

# Run SwiftLint manually
lint:
	@echo "🔍 Running SwiftLint..."
	swiftlint lint

# Run strict linting (same as pre-push hook)
lint-strict:
	@echo "🔍 Running SwiftLint (strict mode)..."
	swiftlint lint --strict

# Run both formatting and linting
validate: format lint
	@echo "✅ All validations passed!"

# Remove git hooks (for troubleshooting)
clean-hooks:
	@echo "🧹 Removing git hooks..."
	lefthook uninstall
	@echo "✅ Git hooks removed!"

# Show current tool versions
versions:
	@echo "📋 Installed tool versions:"
	@echo "SwiftFormat: $$(swiftformat --version 2>/dev/null || echo 'Not installed')"
	@echo "SwiftLint: $$(swiftlint version 2>/dev/null || echo 'Not installed')"
	@echo "Lefthook: $$(lefthook version 2>/dev/null || echo 'Not installed')"

# Help command
help:
	@echo "🚀 Swift Project Development Commands"
	@echo ""
	@echo "📦 Setup:"
	@echo "  make setup         - Complete setup for new team members"
	@echo "  make install-tools - Install SwiftFormat, SwiftLint, and Lefthook"
	@echo "  make setup-hooks   - Install git hooks with Lefthook"
	@echo ""
	@echo "🔧 Development:"
	@echo "  make format        - Format Swift code"
	@echo "  make lint          - Run SwiftLint"
	@echo "  make lint-strict   - Run SwiftLint in strict mode"
	@echo "  make validate      - Run formatting and linting"
	@echo ""
	@echo "🛠️  Maintenance:"
	@echo "  make clean-hooks   - Remove git hooks"
	@echo "  make versions      - Show installed tool versions"
	@echo "  make help          - Show this help message"