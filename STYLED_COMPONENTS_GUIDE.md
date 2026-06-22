# Styled-Components Architecture Guide

## Overview
The Hope Support Suite (HSS) now uses **styled-components exclusively** for all component styling. No CSS files, no Tailwind classes, no global CSS selectors.

## Architecture Principles

### ✅ DO: Using Styled-Components

```typescript
import styled from 'styled-components';

// 1. Simple styled component
const Button = styled.button`
  padding: var(--space-3) var(--space-6);
  background: var(--color-brand-mahogany);
  border: none;
  border-radius: var(--radius-xl);
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--transition-normal);

  &:hover {
    background: var(--color-brand-cognac);
    box-shadow: var(--shadow-mahogany-glow);
  }

  &:active {
    transform: scale(0.98);
  }
`;

// 2. Component-scoped styling
const MyCard = styled.div<{ $highlighted?: boolean }>`
  padding: var(--space-6);
  background: rgba(255, 255, 255, 0.05);
  border-radius: var(--radius-2xl);
  backdrop-filter: blur(40px);
  border: 1px solid rgba(255, 255, 255, ${props => props.$highlighted ? '0.2' : '0.1'});
  transition: all var(--transition-fast);

  &:hover {
    border-color: var(--color-brand-gold);
    background: rgba(255, 255, 255, 0.08);
  }
`;

// 3. Layout with flex/grid
const Container = styled.div<{ $direction?: 'row' | 'column' }>`
  display: flex;
  flex-direction: ${props => props.$direction || 'row'};
  gap: var(--space-4);
  align-items: center;
  justify-content: space-between;

  @media (max-width: 640px) {
    flex-direction: column;
    gap: var(--space-3);
  }
`;

// 4. Using theme from ThemeProvider
const ThemedText = styled.p<{ $variant?: 'primary' | 'secondary' }>`
  color: ${props => 
    props.$variant === 'secondary' 
      ? props.theme.colors.text.secondary 
      : props.theme.colors.text.primary
  };
  font-size: ${props => props.theme.typography.sizes.body};
  line-height: 1.6;
`;

export function MyComponent() {
  return (
    <Container $direction="column">
      <MyCard $highlighted>
        <ThemedText $variant="primary">Hello World</ThemedText>
      </MyCard>
      <Button>Click me</Button>
    </Container>
  );
}
```

### ✅ DO: Using LayoutComponents

Pre-built layout primitives for common patterns:

```typescript
import { PageWrapper, Flex, Stack, Grid, ContentSection } from '@/shared/styles/LayoutComponents';

export function MyPage() {
  return (
    <PageWrapper>
      <ContentSection $spacing="lg">
        {/* Column layout with gap */}
        <Stack $gap="var(--space-6)" $align="center">
          <h1>Title</h1>
          <p>Description</p>
        </Stack>

        {/* Row layout with gap */}
        <Flex $gap="var(--space-4)" $justify="space-between">
          <div>Left item</div>
          <div>Right item</div>
        </Flex>

        {/* Grid layout */}
        <Grid $columns={3} $gap="var(--space-4)">
          <div>Item 1</div>
          <div>Item 2</div>
          <div>Item 3</div>
        </Grid>
      </ContentSection>
    </PageWrapper>
  );
}
```

### ✅ DO: Using CSS Variables

All design tokens are available as CSS custom properties:

```typescript
const StyledCard = styled.div`
  /* Colors */
  background: var(--color-brand-opal);
  color: var(--color-brand-noir);
  border: 1px solid var(--color-brand-gold);

  /* Spacing */
  padding: var(--space-6);
  margin: var(--space-4);
  gap: var(--space-3);

  /* Borders */
  border-radius: var(--radius-2xl);

  /* Shadows */
  box-shadow: var(--shadow-luxe);

  /* Transitions */
  transition: all var(--transition-normal);
`;
```

### ❌ DON'T: Using className with Tailwind

```typescript
// ❌ WRONG - No Tailwind classes
<div className="flex flex-col gap-4 p-6 rounded-2xl bg-white">
  <h1 className="text-3xl font-bold text-gray-900">Title</h1>
</div>

// ✅ RIGHT - Use styled-components
const Container = styled.div`
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  padding: var(--space-6);
  border-radius: var(--radius-2xl);
  background: white;
`;

const Title = styled.h1`
  font-size: 1.875rem;
  font-weight: 900;
  color: var(--color-brand-noir);
`;

<Container>
  <Title>Title</Title>
</Container>
```

### ❌ DON'T: Importing CSS files

```typescript
// ❌ WRONG - No CSS file imports
import './styles.css';

// ✅ RIGHT - All styling is in the component
const MyComponent = styled.div`
  /* styles here */
`;
```

### ❌ DON'T: Using @apply or global CSS

```css
/* ❌ WRONG - No global CSS */
.card {
  @apply p-6 rounded-2xl bg-white shadow-lg;
}

/* ✅ RIGHT - Styles are in components */
const Card = styled.div`
  padding: var(--space-6);
  border-radius: var(--radius-2xl);
  background: white;
  box-shadow: var(--shadow-luxe);
`;
```

## Available Design Tokens

### Colors
- **Brand**: `--color-brand-noir`, `--color-brand-mahogany`, `--color-brand-cognac`, `--color-brand-gold`, `--color-brand-gold-deep`, `--color-brand-champagne`, `--color-brand-ivory`, `--color-brand-emerald`, `--color-brand-opal`

### Spacing
- **Scale**: `--space-1` to `--space-32` (0.25rem to 8rem)

### Border Radius
- **Sizes**: `--radius-sm`, `--radius-md`, `--radius-lg`, `--radius-xl`, `--radius-2xl`, `--radius-3xl`, `--radius-full`

### Shadows
- **Standard**: `--shadow-luxe`, `--shadow-luxe-sm`, `--shadow-luxe-md`, `--shadow-luxe-lg`
- **Glows**: `--shadow-gold-glow`, `--shadow-mahogany-glow`, `--shadow-emerald-glow`, `--shadow-platinum`

### Transitions
- **Speed**: `--transition-fast` (0.15s), `--transition-normal` (0.3s), `--transition-slow` (0.5s)
- **Easing**: `--ease-in-out`, `--ease-out`, `--ease-spring`

### Z-Index
- **Scale**: `--z-base`, `--z-dropdown`, `--z-sticky`, `--z-modal-backdrop`, `--z-modal`, `--z-drawer-backdrop`, `--z-drawer`, `--z-toast`, `--z-tooltip`, `--z-max`

### Gradients
- **Metals**: `--gradient-metal-noir`, `--gradient-metal-gold`

### Typography
- **Fonts**: `--font-sans`, `--font-display`, `--font-serif`, `--font-mono`

## Theme Integration

For advanced theming (using ThemeProvider):

```typescript
import { useTheme } from 'styled-components';

const MyComponent = styled.div`
  /* Using theme props */
  color: ${props => props.theme.colors.text.primary};
  padding: ${props => props.theme.spacing.md};
`;

// In component
function Component() {
  const theme = useTheme();
  // Can access theme properties
}
```

## Migration Checklist

When converting existing components:

- [ ] Remove all `import './styles.css'` statements
- [ ] Remove all `className="..."` Tailwind classes
- [ ] Convert to `styled.*` components or `styled(Component)`
- [ ] Replace numeric values with CSS variables
- [ ] Update responsive breakpoints to use styled-components media queries
- [ ] Move animations from CSS to styled-components or framer-motion
- [ ] Test component rendering
- [ ] Verify hover/focus/active states work correctly

## Best Practices

1. **Co-locate styles with components** - Keep styled components in the same file
2. **Use descriptive names** - `NotFoundButton`, not `Button1`
3. **Organize related styles** - Group related styled components together
4. **Use CSS variables** - Reference tokens, don't hardcode values
5. **Leverage transient props** - Use `$` prefix for non-DOM props (`$highlighted`, `$variant`)
6. **Keep components simple** - Complex logic should be outside styled components
7. **Use TypeScript** - Type your props for better IDE support

## Common Patterns

### Conditional Styling
```typescript
const Card = styled.div<{ $disabled?: boolean }>`
  opacity: ${props => props.$disabled ? 0.5 : 1};
  pointer-events: ${props => props.$disabled ? 'none' : 'auto'};
  transition: all var(--transition-normal);
`;
```

### Responsive Design
```typescript
const Grid = styled.div`
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-4);

  @media (max-width: 1024px) {
    grid-template-columns: repeat(2, 1fr);
  }

  @media (max-width: 640px) {
    grid-template-columns: 1fr;
  }
`;
```

### Extending Components
```typescript
const Button = styled.button`
  /* base styles */
`;

const PrimaryButton = styled(Button)`
  background: var(--color-brand-mahogany);

  &:hover {
    background: var(--color-brand-cognac);
  }
`;
```

## Support
For questions or issues with styled-components, refer to:
- [styled-components documentation](https://styled-components.com)
- [Theme system guide](./THEME_SYSTEM_GUIDE.md)
- [Design tokens reference](./DESIGN_TOKENS.md)
