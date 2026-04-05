# QuickMeet Agent Guide

## Project goal
Rebuild the UI of QuickMeet into a premium iOS-style SwiftUI app while preserving the current app flow and local persistence.

## Read first
1. docs/design/README.md
2. docs/design/design_tokens.json
3. docs/design/screen_specs.md
4. docs/design/user_flows.md
5. docs/design/figma_spec.md
6. docs/design/handoff_notes.md

## Main objective
Rewrite the UI to make the core product value more obvious:
- fast discovery
- fast matching
- fast chat

The UI should feel:
- premium
- clean
- native to iOS
- image-first on Discover
- emotionally stronger on Match Success
- cleaner and more realistic in Chat

## Keep
- SwiftUI
- current navigation structure
- current local persistence
- current basic product flow

## Priorities
1. Design system and reusable components
2. Discover screen
3. Match success modal
4. Messages screen
5. Chat screen
6. Profile and Edit Profile polish

## Constraints
- Do not rewrite the whole architecture unless necessary
- Prefer improving the current structure over introducing heavy abstractions
- Keep files understandable and small
- Avoid breaking existing data flow

## Design direction
- light background
- restrained purple/pink accents
- stronger typography hierarchy
- large rounded cards
- soft shadows
- clean spacing
- minimal explanatory copy
- realistic sample data

## Definition of done
- Discover feels like the hero screen
- Match success feels rewarding
- Chat feels like a real app, not a mock
- Profile editing still works
- Spacing and visual hierarchy are consistent
