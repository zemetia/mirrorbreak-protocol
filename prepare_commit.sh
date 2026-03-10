#!/bin/bash
# Prepare MBP v2.0 for GitHub push

cd /home/zemetia/projects/mirrorbreak-protocol

echo "📦 Preparing MBP v2.0 for commit..."

# Create symlink or copy reference
echo "🔗 Linking backend-v2 to research folder..."

# Add to git
git add system-implementation-plan/AGENT-ARCHITECTURE-v2.md
git add system-implementation-plan/IMPLEMENTATION-ROADMAP-v2.md

echo "✅ Preparation complete!"
echo ""
echo "Next steps:"
echo "1. Copy /mnt/d/Yoel/projects/mbp-prototype/backend-v2 to separate repo (if desired)"
echo "2. Or add as submodule to mirrorbreak-protocol"
echo "3. Run: git commit -m 'Add MBP v2.0 implementation'"
echo "4. Run: git push origin master"
