# NeuroStudy Visual Style Guide

## Design Token Reference

### 🎨 Color System

#### Primary Palette
```swift
// Accent Color (System-provided)
Color.accentColor              // Primary interactive color

// Brain Region Colors (Preserved from original)
.frontalLobe:   Color.blue     // Executive functions
.parietalLobe:  Color.green    // Sensory processing
.temporalLobe:  Color.purple   // Memory & language
.occipitalLobe: Color.pink     // Visual processing
.subcortical:   Color.orange   // Deep structures
.brainstem:     Color.red      // Vital functions
.cerebellum:    Color.cyan     // Motor coordination
```

#### Semantic Colors
```swift
// Mastery Levels
.new:        Color.secondary   // Not yet studied
.learning:   Color.blue        // In progress
.struggling: Color.red         // Needs attention
.reviewing:  Color.orange      // Due for review
.mastered:   Color.green       // Fully learned

// Quiz Modes
.tapIdentify:     Color.blue   // Interactive identification
.flashcard:       Color.purple // Spaced repetition
.multipleChoice:  Color.green  // Knowledge testing

// Status Indicators
.success: Color.green
.warning: Color.orange
.error:   Color.red
.info:    Color.blue
```

#### Opacity Scales
```swift
// Background fills
.opacity(0.08)  // Subtle tint
.opacity(0.12)  // Light background
.opacity(0.15)  // Standard background
.opacity(0.2)   // Prominent background
.opacity(0.3)   // Strong background

// Borders & strokes
.opacity(0.2)   // Subtle border
.opacity(0.3)   // Standard border
.opacity(0.4)   // Prominent border
.opacity(0.5)   // Strong border
```

---

### 📐 Spacing System

#### Standard Increments (4pt base)
```swift
let spacing4  = 4.0   // Minimal spacing
let spacing6  = 6.0   // Tight spacing
let spacing8  = 8.0   // Default small
let spacing10 = 10.0  // Compact
let spacing12 = 12.0  // Standard
let spacing14 = 14.0  // Comfortable
let spacing16 = 16.0  // Default large
let spacing18 = 18.0  // Generous
let spacing20 = 20.0  // Extra large
let spacing24 = 24.0  // Section spacing
```

#### Card Padding
```swift
// Internal padding
.small:      12pt
.medium:     16pt (default)
.large:      20pt
.extraLarge: 24pt
```

#### Corner Radius
```swift
// Standard radii
.chip:      6pt   // Small pills
.badge:     8pt   // Badge containers  
.button:    10pt  // Standard buttons
.card:      12pt  // Compact cards
.standard:  14pt  // Default cards
.prominent: 18pt  // Important cards
.large:     20pt  // Large cards
.hero:      24pt  // Hero cards
.extra:     28pt  // Extra prominent
```

---

### 📝 Typography

#### Font Hierarchy
```swift
// Display
.heroTitle         // .largeTitle, rounded, bold
.title             // .title, rounded, semibold
.title2            // .title2, rounded, semibold
.title3            // .title3, rounded, semibold

// Body
.headline          // .headline, rounded, semibold
.subheadline       // .subheadline, rounded, medium
.body              // .body, default
.callout           // .callout, default

// Support
.caption           // .caption, rounded, medium
.caption2          // .caption2, rounded, medium

// Custom Semantic
.structureTitle    // .title2, rounded, semibold
.structureSubtitle // .subheadline, rounded, medium
.cardTitle         // .title3, rounded, semibold
.sectionHeader     // .headline, rounded, semibold
.quizPrompt        // .title3, rounded, medium
.scoreDisplay      // .largeTitle, rounded, bold
.regionBadge       // .caption, rounded, bold
.detailLabel       // .caption, rounded, medium
.microText         // .caption2, rounded, medium
```

#### Font Weights
```swift
.ultraLight  // 100 - Very thin
.thin        // 200 - Thin
.light       // 300 - Light
.regular     // 400 - Normal (default)
.medium      // 500 - Medium emphasis
.semibold    // 600 - Strong emphasis
.bold        // 700 - Bold
.heavy       // 800 - Very bold
.black       // 900 - Extra bold
```

#### Font Design
```swift
.default     // System default (San Francisco)
.rounded     // SF Rounded (friendly, modern)
.serif       // New York (formal)
.monospaced  // SF Mono (technical)
```

---

### 🎭 Material System

#### Standard Materials
```swift
.ultraThinMaterial   // Subtle blur, primary choice
.thinMaterial        // Light blur
.regularMaterial     // Medium blur
.thickMaterial       // Strong blur
.ultraThickMaterial  // Maximum blur
```

#### Usage Guidelines
- **Cards**: `.ultraThinMaterial` (default)
- **Prominent Cards**: `.thinMaterial` with gradient overlay
- **Buttons**: `.ultraThinMaterial` (standard), `.regularMaterial` (prominent)
- **Backgrounds**: Adaptive gradient (not material)
- **Overlays**: `.ultraThinMaterial` for temporary UI

---

### 🎬 Animation System

#### Spring Parameters
```swift
// Quick & Snappy (UI feedback)
.spring(response: 0.3, dampingFraction: 0.7)

// Standard (most interactions)
.spring(response: 0.35, dampingFraction: 0.75)

// Smooth (entrance animations)
.spring(response: 0.4, dampingFraction: 0.8)

// Gentle (large movements)
.spring(response: 0.5, dampingFraction: 0.8)

// Bouncy (playful interactions)
.spring(response: 0.4, dampingFraction: 0.6)
```

#### Timing Constants
```swift
let quickTap     = 0.2  // Button press
let standard     = 0.3  // Most transitions
let comfortable  = 0.4  // Card animations
let leisurely    = 0.5  // Entrance effects
let dramatic     = 0.8  // Progress animations
```

#### Delay Patterns
```swift
// Staggered list items
ForEach(items.enumerated(), id: \.element.id) { index, item in
    view(item)
        .animation(
            .spring(response: 0.5)
                .delay(Double(index) * 0.08), // 80ms stagger
            value: appeared
        )
}
```

#### Transition Combinations
```swift
// Standard entrance
.opacity.combined(with: .move(edge: .top))

// Scale entrance
.scale(scale: 0.95).combined(with: .opacity)

// Asymmetric (different in/out)
.asymmetric(
    insertion: .scale(scale: 0.92).combined(with: .opacity),
    removal: .opacity
)
```

---

### 🖼️ Icon System

#### Icon Sizes
```swift
// Tiny
let icon8  = 8.0   // Micro badges
let icon9  = 9.0   // Badge symbols

// Small
let icon10 = 10.0  // Filter chips
let icon11 = 11.0  // Compact UI
let icon12 = 12.0  // Secondary icons

// Medium (default)
let icon14 = 14.0  // Standard icons
let icon16 = 16.0  // Prominent icons
let icon18 = 18.0  // Section headers

// Large
let icon20 = 20.0  // Large buttons
let icon22 = 22.0  // Close buttons
let icon24 = 24.0  // Quiz mode icons

// Extra Large
let icon28 = 28.0  // Hero icons
let icon36 = 36.0  // Feature icons
let icon44 = 44.0  // Large feature icons
```

#### Standard Symbols
```swift
// Navigation
"brain.head.profile"      // Explore tab
"questionmark.circle.fill" // Quiz tab
"chart.bar.fill"          // Progress tab
"arrow.right.circle.fill" // Forward action
"xmark.circle.fill"       // Close action
"chevron.right"           // List navigation

// Brain Regions
"brain"                   // General brain
"circle.hexagonpath"      // Frontal
"square.stack.3d.up"      // Parietal
"waveform"                // Temporal
"eye"                     // Occipital
"circle.dotted"           // Subcortical

// Status
"checkmark.circle.fill"   // Success
"star.fill"               // Mastery
"target"                  // Accuracy
"arrow.clockwise"         // Review
"exclamationmark.triangle" // Warning

// Quiz Modes
"hand.point.up.braille"   // Tap Identify
"rectangle.stack"         // Flashcard
"list.bullet.clipboard"   // Multiple Choice
```

---

### 📦 Component Specifications

#### LiquidGlassCard
```swift
// Standard variant
LiquidGlassCard(
    cornerRadius: 20,
    padding: 16,
    interactive: false,
    prominent: false
) { /* content */ }

// Prominent variant (hero cards)
LiquidGlassCard(
    cornerRadius: 24,
    padding: 20,
    prominent: true
) { /* content */ }

// Compact variant
LiquidGlassCard(
    cornerRadius: 16,
    padding: 12
) { /* content */ }
```

#### ModernGlassButtonStyle
```swift
// Small button (settings, compact UI)
.buttonStyle(ModernGlassButtonStyle(
    isProminent: false,
    size: .small
))

// Medium button (default)
.buttonStyle(ModernGlassButtonStyle(
    isProminent: true,
    size: .medium
))

// Large button (primary actions)
.buttonStyle(ModernGlassButtonStyle(
    isProminent: true,
    size: .large
))
```

#### ModernRegionBadge
```swift
// Compact (icon only)
ModernRegionBadge(region: .frontalLobe, style: .compact)

// Standard (icon + label)
ModernRegionBadge(region: .frontalLobe, style: .standard)

// Prominent (larger, with shadow)
ModernRegionBadge(region: .frontalLobe, style: .prominent)
```

#### ModernMasteryBadge
```swift
// Standard (with label)
ModernMasteryBadge(
    level: .mastered,
    showLabel: true,
    animated: false
)

// Compact (icon only)
ModernMasteryBadge(
    level: .mastered,
    showLabel: false
)

// Animated (pulsing effect for mastered)
ModernMasteryBadge(
    level: .mastered,
    animated: true
)
```

#### OptimizedCircularProgress
```swift
// Small (100pt)
OptimizedCircularProgress(
    progress: 0.75,
    label: "Progress",
    lineWidth: 8,
    size: 100
)

// Medium (130pt) - Quiz stats
OptimizedCircularProgress(
    progress: 0.75,
    label: "Mastery",
    lineWidth: 10,
    size: 130,
    accentColors: [.blue, .purple, .pink, .orange]
)

// Large (160pt) - Hero cards
OptimizedCircularProgress(
    progress: 0.75,
    label: "Mastery",
    lineWidth: 14,
    size: 160,
    accentColors: [.blue, .cyan, .purple, .pink]
)
```

---

### 🎯 Touch Target Guidelines

#### Minimum Sizes (iOS Human Interface Guidelines)
```swift
let minTouchTarget  = 44.0  // iOS minimum
let comfortableTouch = 48.0  // Comfortable
let largeTouchTarget = 56.0  // Large controls
```

#### Spacing Around Targets
```swift
let minSpacing = 8.0   // Minimum between interactive elements
let comfortSpacing = 12.0  // Comfortable spacing
```

---

### 🌈 Gradient Patterns

#### Background Gradients (Dark Mode)
```swift
LinearGradient(
    colors: [
        Color(red: 0.08, green: 0.05, blue: 0.15), // Deep purple-blue
        Color(red: 0.03, green: 0.08, blue: 0.12), // Dark blue
        Color(red: 0.05, green: 0.03, blue: 0.10)  // Deep indigo
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

#### Background Gradients (Light Mode)
```swift
LinearGradient(
    colors: [
        Color(red: 0.93, green: 0.94, blue: 0.98), // Soft lavender
        Color(red: 0.96, green: 0.95, blue: 0.98), // Light purple-white
        Color(red: 0.94, green: 0.96, blue: 0.99)  // Soft blue-white
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

#### Card Border Gradients
```swift
LinearGradient(
    colors: [
        .white.opacity(0.45),  // Top highlight
        .white.opacity(0.08)   // Bottom fade
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

#### Progress Ring Gradients
```swift
// 4-color gradient
AngularGradient(
    colors: [.blue, .purple, .pink, .orange, .blue],
    center: .center
)

// 3-color gradient (simpler)
AngularGradient(
    colors: [.blue, .cyan, .purple, .blue],
    center: .center
)
```

#### Icon Background Gradients
```swift
// Radial (for circular icons)
RadialGradient(
    colors: [
        color.opacity(0.3),  // Center
        color.opacity(0.12)  // Edge
    ],
    center: .center,
    startRadius: 5,
    endRadius: 20
)

// Linear (for square icons)
LinearGradient(
    colors: [
        color.opacity(0.2),
        color.opacity(0.08)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

---

### 📐 Layout Patterns

#### Card Layouts
```swift
// Standard card
VStack(alignment: .leading, spacing: 12) {
    // Header
    // Content
    // Footer
}
.padding(16)

// Hero card
VStack(spacing: 16) {
    // Centered content
}
.padding(20)

// Compact card
HStack(spacing: 10) {
    // Horizontal content
}
.padding(12)
```

#### List Item Layouts
```swift
HStack(spacing: 12) {
    // Icon (36-40pt circle)
    // Content (VStack with title + subtitle)
    Spacer()
    // Trailing (badges, chevrons)
}
.padding(.horizontal, 14)
.padding(.vertical, 12)
```

#### Grid Layouts
```swift
HStack(spacing: 12) {
    ForEach(items) { item in
        // Equal width items
    }
    .frame(maxWidth: .infinity)
}
```

---

## Usage Examples

### Creating a Custom Card
```swift
LiquidGlassCard(cornerRadius: 20, padding: 16) {
    VStack(alignment: .leading, spacing: 12) {
        // Header with badge
        HStack {
            ModernRegionBadge(region: .frontalLobe, style: .standard)
            Spacer()
            Text("Additional info")
                .font(.microText)
                .foregroundStyle(.secondary)
        }
        
        // Title
        Text("Card Title")
            .font(.cardTitle)
        
        // Description
        Text("Card description with more detail about the content")
            .font(.bodyText)
            .foregroundStyle(.secondary)
        
        // Action
        Button("Action") { }
            .buttonStyle(ModernGlassButtonStyle(isProminent: true))
    }
}
```

### Creating a Stat Display
```swift
VStack(spacing: 6) {
    // Icon with gradient background
    ZStack {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color.opacity(0.3), color.opacity(0.12)],
                    center: .center,
                    startRadius: 5,
                    endRadius: 20
                )
            )
            .frame(width: 44, height: 44)
        
        Image(systemName: icon)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(color)
    }
    
    // Value
    Text(value)
        .font(.system(.title3, design: .rounded, weight: .bold))
    
    // Label
    Text(label)
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
}
```

---

## Design Principles Summary

1. **Consistency**: Use standard spacing, corner radii, and animations
2. **Hierarchy**: Clear visual importance through size, weight, and color
3. **Feedback**: Animate interactions with spring physics
4. **Performance**: Use lazy loading and optimized rendering
5. **Accessibility**: Support Dynamic Type and VoiceOver
6. **Platform**: Adapt to iOS, iPadOS, and macOS conventions

---

**Style Guide Version**: 1.0  
**Last Updated**: February 15, 2026  
**Maintained By**: Design System Team
