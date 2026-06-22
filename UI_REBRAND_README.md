# Espy UI Rebranding Guide: Blue-Flame Identity

This document maps the transformation from **Hope Support Suite** to **Espy**. The new identity centers on a "blue-flame" aesthetic: calm, professional, and human.

---

## 1. Global Visual Identity (Espy)

### **Core Color Palette**
| Token | HEX / Value (Proposed) | Role |
|:---|:---|:---|
| `Deep Navy` | `#0A192F` | Primary Background, Side Menu, Noir Replacement. |
| `Electric Blue` | `#0077FF` | Core Flame Hue, Interactive Elements. |
| `Cyan / Ice` | `#00D4FF` | Flame Highlight, Secondary Gradients. |
| `Gold` | `#D4AF37` | Institution Signal, Super-likes, SOS Accents. |
| `Ivory` | `#F2E8CE` | Main Content Canvas (Visitor), Text Contrast. |
| `White` | `#FFFFFF` | Primary Typography, Clean Icons. |

### **Motion & Animation Tokens**
*   **Flame Ripple**: Glow effect on buttons and active nav items.
*   **Shimmer Sweep**: Gradient transition on cards and banners.
*   **Breathing Pulse**: Constant subtle `AnimatedScale` on map pins.
*   **Flame Burst**: `Curves.elasticOut` expansion for modals and SOS activation.

---

## 2. Mobile App: Component Transformation (Flutter)

### **Directory & Map**
*   **Pins**: 
    *   Professionals -> Blue flame icons with sector-specific interior icons.
    *   Institutions -> Gold flame icons.
    *   *Animation*: Pulse on idle, Glow on tap.
*   **Overlay**: Glassmorphic filter bar + Blue-to-Cyan gradient header.

### **Swipe & Match (`lib/screens/matching/`)**
*   **`CardSwiper`**: Integrated `Lottie.asset` flame trail on drag.
*   **`ProfessionalCard`**: 2px Blue-flame border + Shimmering verified badge.
*   **`RequestCard`**: Ivory base with pulse-red-gold border for SOS requests.
*   **Feedback**: Right (Flame Burst), Left (Fade), Super-like (Gold Spark Explosion).

### **Navigation & Menus**
*   **Side Menu**: Deep navy background with gold hover glows.
*   **Professional Bar**: Metallic blue gradient with white icons.
*   **Visitor Bar**: Ivory base with gold icons + Pulsing center flame orb.
*   **SOS Button**: Expands with flame burst + haptic feedback.

---

## 3. Admin Dashboard: Component Transformation (React)

### **Foundation (`EnhancedUIComponents.tsx`)**
*   **`Button`**: Blue flame gradient + Shimmer hover.
*   **`Card`**: Glass variant (Deep blur) + Premium Ivory/Gold borders.
*   **`Badge`**: Rounded pill with Flame Gradient background.
*   **`Alert`**: Banner with blue flame glow emphasis.

### **Loading & Analytics**
*   **`FullPageLoader`**: Radial blue flame glow.
*   **`InlineLoader`**: Spinning flame border.
*   **`DailyAnalyticsChart`**: Line/Area charts using Blue-to-Cyan gradients.

---

## 4. Implementation Checklist

### **Phase 1: Theme Hardening**
- [ ] Update `lib/core/theme.dart` with `espyBlueFlame` gradients.
- [ ] Update `.../styles/tokens/theme-tokens.ts` for Admin Dashboard.

### **Phase 2: Mobile UI Refactor**
- [ ] Implement `FlamePainter` for custom canvas animations.
- [ ] Refactor `GlowGearButton` for Blue-Flame pulse.
- [ ] Apply glassmorphism to all Wizard sheets.

### **Phase 3: Admin Re-skin**
- [ ] Override `StyledButton` variants in `EnhancedUIComponents.tsx`.
- [ ] Update Sidebar (DashboardShell) with Navy-Blue gradient.
