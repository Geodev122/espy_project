# Implementation Plan - Navigation & UI Optimization

This plan addresses several navigation, UI, and feature requests for the "pro app" and "visitor app," focusing on centralized management, improved matching behavior, and store redesign.

## Proposed Changes

### 1. Centralized Management & Navigation Fixes
- **Dashboard Navigation Fix**: Wrap `DashboardScreen` and `ServiceManagerScreen` content in a shell that provides a consistent app bar if they are accessed outside the main `AppShell` (or ensure they are always used within the `IndexedStack` of `AppShell`).
- **Side Menu Cleanup**: Remove 'Subscription Vault' and 'Dispatch Broadcast'. Add 'Broadcast History'.
- **Page Deletion**: Delete `SubscriptionHubScreen` as the system has moved to tokens.

### 2. Matching Behavior Enhancements (Pro & Visitor Apps)
- **Favoriting**:
    - Support Swipe Left to mark as favorite.
    - Support Swiping top/other directions as needed.
- **Badges**:
    - "Favorite" badge for saved items.
    - "Previously Contacted" badge for items in `directory_interactions` with type `like` or `request_match`.
- **UI Adjustments**:
    - Remove redundant page titles.
    - Increase bottom margins for cards to avoid overlap with action buttons.
    - Add "Refresh" button when cards are exhausted to restart the loop.

### 3. Espy Store Redesign (`TokenShopScreen`)
- **Compact Layout**: Redesign item cards to be more compact.
- **Clarification**: Clearly distinguish between "Activate New" and "Renew Current" items using labels and visual grouping.

---

## Technical Details

### `DashboardScreen`
- Update `onTap` for "MANAGE SLOTS" to navigate to `ServiceManagerScreen` (current logic seems correct, but user reports it's not opening in a "proper app page shell"). I will wrap the destination in a `Scaffold` if needed, or check if it's because it's missing an `AppBar` when pushed.

### `MatchingScreen` & `SwipeRequestsScreen`
- **Badges Logic**: I will need to fetch `directory_favorites` and `directory_interactions` for the current user to display badges.
- **Swipe Logic**:
    - Right: Contact (WhatsApp) + record interaction.
    - Left: Favorite + toggle favorite in DB.
    - Top/Bottom: Skip.
- **End State**: Replace the current "Queue Cleared" card with a card containing a "RESTART PROTOCOL" button.

### Side Menu (`EspySideMenu`)
- Remove `SubscriptionHubScreen` import and menu item.
- Remove `BroadcastScreen` menu item.
- Add `BroadcastHistoryScreen` menu item.

### [NEW] `BroadcastHistoryScreen`
- A new screen that displays `directory_broadcasts` filtered by the current user's ID.

---

## Verification Plan

### Automated Tests
- N/A (Project uses manual verification for UI flows).

### Manual Verification
- **Side Menu**: Verify removal of items and addition of 'Broadcast History'.
- **Dashboard**: Click 'Manage Slots' and verify it opens correctly with an `AppBar`.
- **Matching (Pro & Visitor)**:
    - Swipe left to favorite.
    - Check for 'Favorite' badge on refresh.
    - Check for 'Previously Contacted' badge after contacting.
    - Verify cards don't overlap buttons.
- **Espy Store**: Verify new compact layout and clear "Activate" vs "Renew" labels.
- **Deletion**: Verify `SubscriptionHubScreen` is gone.
